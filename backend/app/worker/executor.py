import json
import time

from sqlalchemy import text
from app.db.session import SessionLocal
from app.models.job import Job

from app.core.logger import logger
from app.core.observability.metrics import increment
from app.core.observability.trace import start_trace, end_trace

from app.core.learning.learning_orchestrator import run_learning_cycle
from app.core.learning.policies.policy_engine import select_policy
from app.core.learning.feedback import update_policy_metrics
from app.core.learning.agents.agent_metrics import update_agent_score
from app.core.intelligence.memory.learning_memory import store_learning_event

from app.core.creative.orchestrator.generation_orchestrator import generate_creatives
from app.core.creative.selector import select_top_creatives

from app.core.integrations.meta.sync_service import sync_meta_data
from app.core.security.execution_guard import validate_job_execution
from app.core.security.circuit_breaker import record_failure

from app.core.intelligence.context.context_builder import build_context
from app.core.intelligence.goals.goal_engine import get_active_goals
from app.core.intelligence.planning.planner import build_plan
from app.core.intelligence.reasoning.reasoning_engine import reason
from app.core.intelligence.strategy.strategy_selector import select_final_strategy

from app.core.integration.meta_actions import pause_campaign, increase_budget
from app.core.intelligence.feedback.feedback_optimizer import optimize_from_feedback

from app.core.testing.mock_metrics_engine import update_mock_metrics
from app.core.testing.fatigue_engine import detect_fatigue
from app.core.testing.experiment_manager import start_experiment
from app.core.testing.winner_selector import select_winner


# =========================
# HELPERS
# =========================
def parse_payload(payload):
    if payload is None:
        return {}
    if isinstance(payload, dict):
        return payload
    if isinstance(payload, str):
        try:
            return json.loads(payload)
        except:
            return {}
    return {}


# =========================
# AI JOB EXECUTION
# =========================
def execute_ai_job(job, payload):
    mode = payload.get("mode", "default")

    logger.info("ai_job_execution_started", extra={
        "job_id": str(job.id),
        "mode": mode
    })

    if mode == "explore":
        time.sleep(1.5)
    elif mode == "exploit":
        time.sleep(0.5)
    else:
        time.sleep(1)

    result = {"status": "success", "mode": mode}

    logger.info("ai_job_execution_completed", extra={
        "job_id": str(job.id)
    })

    return result


# =========================
# EXECUTOR
# =========================
def execute_job(job_id):
    db = SessionLocal()
    trace = start_trace()
    start_time = time.time()

    job = None
    policy_id = None
    agent_name = "fallback"

    try:
        # STEP 1: FETCH JOB
        job = db.query(Job).filter(Job.id == job_id).first()
        if not job:
            return {"error": "Job not found"}

        increment("jobs_total", 1)
        validate_job_execution(job)

        payload = parse_payload(job.payload)

        # =========================
        # META SYNC
        # =========================
        if payload.get("enable_meta_sync", False):
            try:
                sync_meta_data(
                    ad_account_id=payload.get("ad_account_id", "test_account")
                )
            except Exception as e:
                logger.warning("meta_sync_failed", extra={"error": str(e)})

        # =========================
        # POLICY
        # =========================
        policy, _ = select_policy(job.type, payload)
        if not policy:
            raise Exception("No policy found")

        policy_id = policy.get("id")
        agent_name = policy.get("agent_name", "fallback")

        job.status = "running"
        job.policy_id = policy_id
        db.commit()

        # =========================
        # INTELLIGENCE
        # =========================
        context = build_context(job, payload, db)

        memory = {}
        metrics = policy.get("metrics", {}) or {}
        memory["avg_latency"] = metrics.get("avg_latency", 0)
        memory["success_rate"] = metrics.get("success_rate", 0)

        goals = get_active_goals()
        plan = build_plan(goals, context)

        decisions = reason(plan, memory)
        strategy = select_final_strategy(decisions)

        logger.info("strategy_selected", extra={"strategy": strategy})

        # =========================
        # CREATIVE SELECTION (FIXED)
        # =========================
        selected_creatives = select_top_creatives(limit=5)

        if selected_creatives:
            logger.info("reusing_top_creatives", extra={
                "count": len(selected_creatives)
            })

            for cid in selected_creatives:
                db.execute(text("""
                    INSERT INTO creative_metrics (
                        creative_id, ctr, cpa, roas, frequency, updated_at
                    )
                    SELECT creative_id, ctr, cpa, roas, frequency, NOW()
                    FROM creative_metrics
                    WHERE creative_id = :cid
                    ORDER BY updated_at DESC
                    LIMIT 1
                """), {"cid": cid})

            db.commit()

        else:
            logger.info("no_top_creatives_found_generating")

            generate_creatives(
                product_id=payload.get("product_id", "default"),
                ad_account_id=payload.get("ad_account_id", "test_account"),
                auto_deploy=payload.get("auto_deploy", False)
            )

        # =========================
        # EXECUTION
        # =========================
        job_type = (job.type or "").lower()

        try:
            if job_type == "ai":
                result = execute_ai_job(job, {**payload, "mode": strategy})
            else:
                result = {"status": "success"}

            success = result.get("status") == "success"

        except Exception as e:
            success = False
            result = {"status": "failed", "error": str(e)}

        latency = int((time.time() - start_time) * 1000)

        # =========================
        # PHASE 7 TESTING
        # =========================
        update_mock_metrics()

        fatigued = detect_fatigue()

        if fatigued:
            logger.info("fatigue_triggered", extra={"count": len(fatigued)})

            generate_creatives(
                product_id=payload.get("product_id", "default"),
                ad_account_id=payload.get("ad_account_id", "test_account"),
                auto_deploy=payload.get("auto_deploy", False)
            )

        winner = select_winner()
        if winner:
            logger.info("creative_winner_selected", extra={"creative_id": winner})

        if strategy == "generate_creative":
            start_experiment(creative_id="latest_batch")

        # =========================
        # FEEDBACK
        # =========================
        optimize_from_feedback(
            policy_id=policy_id,
            success=success,
            latency=latency
        )

        db.execute(text("""
            INSERT INTO strategy_memory (
                policy_id, strategy, success, latency, context
            )
            VALUES (
                :policy_id, :strategy, :success, :latency, :context
            )
        """), {
            "policy_id": policy_id,
            "strategy": strategy,
            "success": success,
            "latency": latency,
            "context": json.dumps(context)
        })

        # =========================
        # POLICY SCORE UPDATE
        # =========================
        score_delta = 1.5 if success else -1.0
        score_delta += 0.5 if latency < 1200 else -0.3

        db.execute(text("""
            UPDATE policies
            SET usage_count = COALESCE(usage_count, 0) + 1,
                last_used = NOW(),
                score = COALESCE(score, 0) + :score_delta
            WHERE id = :policy_id
        """), {
            "policy_id": policy_id,
            "score_delta": score_delta
        })

        # =========================
        # SAVE RESULT
        # =========================
        job.status = "completed"
        job.result = json.dumps(result)
        job.error = None
        db.commit()

        # =========================
        # LEARNING
        # =========================
        update_policy_metrics(policy_id, success, latency)
        store_learning_event(policy_id, success, latency)
        update_agent_score(agent_name, success)

        run_learning_cycle()

        end_trace(trace)

        return {"job_id": str(job.id), "status": "completed"}

    except Exception as e:
        db.rollback()

        logger.error("executor_error", extra={"error": str(e)}, exc_info=True)

        if job:
            job.status = "failed"
            job.error = str(e)
            db.commit()

        record_failure("global")

        return {"error": str(e)}

    finally:
        db.close()
