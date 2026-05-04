import json
import time

from sqlalchemy import text
from app.db.session import SessionLocal
from app.models.job import Job

from app.services.policy_selector import select_policy
from app.services.action_guard import ActionLimiter
from app.services.decision_mapper import map_decision_to_action

from app.core.logger import logger
from app.core.observability.metrics import increment
from app.core.observability.trace import start_trace, end_trace

from app.services.synthetic_creative_generator import generate_synthetic_creatives
from app.core.creative.orchestrator.generation_orchestrator import generate_creatives
from app.core.creative.selector import select_top_creatives
from app.core.testing.winner_selector import select_winner
from app.services.safety_guard import validate_action

from app.core.security.execution_guard import validate_job_execution

from app.services.feedback_worker import process_feedback


# =========================
# HELPERS
# =========================
def parse_payload(payload):
    if isinstance(payload, dict):
        return payload
    try:
        return json.loads(payload) if payload else {}
    except:
        return {}


def normalize_creatives(creatives):
    normalized = []

    for c in creatives:
        try:
            if isinstance(c, str):
                normalized.append({
                    "creative_id": c,
                    "ctr": 0.5,
                    "roas": 1.0,
                    "cpa": 200
                })
                continue

            if hasattr(c, "_mapping"):
                data = dict(c._mapping)
            elif isinstance(c, dict):
                data = c
            else:
                continue

            cid = data.get("creative_id") or data.get("id")
            if not cid:
                continue

            normalized.append({
                "creative_id": cid,
                "ctr": float(data.get("ctr", 0.5)),
                "roas": float(data.get("roas", 1.0)),
                "cpa": float(data.get("cpa", 200)),
            })

        except Exception as e:
            print("[NORMALIZE ERROR]", str(e))

    return normalized


# =========================
# MAIN EXECUTOR
# =========================
def execute_job(job_id):
    db = SessionLocal()
    trace = start_trace()
    start_time = time.time()

    try:
        # =========================
        # FETCH JOB
        # =========================
        job = db.query(Job).filter(Job.id == job_id).first()
        if not job:
            return {"error": "Job not found"}

        increment("jobs_total", 1)
        validate_job_execution(job)

        payload = parse_payload(job.payload)

        # =========================
        # POLICY
        # =========================
        policy = select_policy(db, agent_type="test_job")
        if not policy:
            raise Exception("No policy found")

        policy_id = policy["id"]

        job.status = "running"
        job.policy_id = policy_id
        db.commit()

        print(f"[POLICY] {policy_id}")

        # =========================
        # CREATIVES
        # =========================
        creatives = select_top_creatives(limit=5)

        if not creatives:
            generate_creatives(
                product_id=payload.get("product_id", "default"),
                ad_account_id=payload.get("ad_account_id", "test"),
                auto_deploy=False,
            )
            creatives = select_top_creatives(limit=5)

        creatives = normalize_creatives(creatives)

        if not creatives:
            creatives = [
                {"creative_id": "fallback_1", "ctr": 1.0, "roas": 2.0, "cpa": 120},
                {"creative_id": "fallback_2", "ctr": 0.8, "roas": 1.5, "cpa": 180},
            ]

        # CONTROLLED TEST WINNER (SAFE)

        creatives = generate_synthetic_creatives(5)

        winner = select_winner(creatives)

        if not winner:
            raise Exception("No winner selected")

        creative_id = winner["creative_id"]
        print(f"[WINNER] {creative_id}")

        # =========================
        # POLICY CONFIDENCE
        # =========================
        row = db.execute(
            text("SELECT confidence FROM policies WHERE id = :pid"),
            {"pid": policy_id}
        ).fetchone()

        confidence = float(row.confidence or 0) if row else 0

        # =========================
        # DECISION ENGINE
        # =========================
        decision_output = map_decision_to_action(
            policy=policy,
            confidence=confidence,
            metrics={
                "ctr": winner.get("ctr", 0),
                "roas": winner.get("roas", 0),
                "cpa": winner.get("cpa", 0),
            }
        ) or {}

        action = decision_output.get("action", "hold")
        decision = decision_output.get("decision", "insufficient_data")

        print(f"[DECISION] {action} | {decision}")

        # =========================
        # SAFETY LAYER
        # =========================
        metrics = {
            "ctr": winner.get("ctr", 0),
            "roas": winner.get("roas", 0),
            "cpa": winner.get("cpa", 0),
        }

        safety = validate_action(action, metrics, confidence) or {}

        final_action = safety.get("final_action", action)
        reason = safety.get("reason", "no_reason")

        print(f"[SAFETY] base={action} → final={final_action} | reason={reason}")

        # =========================
        # LIMITER
        # =========================
        limiter = ActionLimiter()

        if not limiter.allow(final_action):
            print("[BLOCKED]", final_action)
            final_action = "hold"

        action = final_action

        print(f"[FINAL ACTION] {action}")

        # =========================
        # LOGGING
        # =========================
        try:
            db.execute(text("""
                INSERT INTO action_logs (creative_id, action, decision, confidence)
                VALUES (:cid, :action, :decision, :conf)
                ON CONFLICT (creative_id, decision, date_trunc('hour', timestamp))
                DO UPDATE SET
                    action = EXCLUDED.action,
                    confidence = EXCLUDED.confidence,
                    timestamp = NOW()
            """), {
                "cid": creative_id,
                "action": action,
                "decision": decision,
                "conf": float(confidence)
            })
            db.commit()

        except Exception as e:
            print("[LOG ERROR]", str(e))
            db.rollback()

        # =========================
        # EXECUTION
        # =========================
        if action == "scale":
            print("[EXECUTION] Scaling")
        elif action == "pause":
            print("[EXECUTION] Pausing")
        else:
            print("[EXECUTION] Hold")

        # =========================
        # COMPLETE JOB
        # =========================
        job.status = "completed"
        job.result = json.dumps({
            "policy_id": str(policy_id),
            "creative_id": str(creative_id),
            "decision": decision_output
        })

        db.commit()

# =========================
# LEARNING FEEDBACK LOOP
# =========================
        try:
            process_feedback(
                creative_id=winner["creative_id"],
                action=final_action,
                decision=decision_output.get("decision", "unknown"),
                confidence=float(decision_output.get("confidence", 0)),
                metrics=winner
            )
        except Exception as e:
            print("[FEEDBACK ERROR]", str(e))

        increment("job_success", 1)

        return {
            "status": "success",
            "decision": decision_output
        }

    except Exception as e:
        db.rollback()
        increment("job_failure", 1)

        logger.error("executor_error", extra={
            "job_id": str(job_id),
            "error": str(e)
        })

        return {"error": str(e)}

    finally:
        db.close()
        end_trace(trace)
