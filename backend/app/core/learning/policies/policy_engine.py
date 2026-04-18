import random
import logging
from sqlalchemy import text

from app.core.observability.metrics import increment
from app.core.observability.trace import start_trace, end_trace

from app.core.learning.policies.scoring import compute_policy_score
from app.db.session import SessionLocal

logger = logging.getLogger(__name__)
security_logger = logging.getLogger("security")

# =========================
# GLOBAL FALLBACK POLICY
# =========================
FALLBACK_POLICY = {
    "id": "fallback",
    "agent_type": "fallback",
    "condition": {},
    "action": {"type": "noop"},
    "weight": 1,
    "confidence": 0.0,
    "score": 0.1,
    "final_score": 0.1,
    "metrics": {
        "success_rate": 0.5,
        "failure_rate": 0.5,
        "total_runs": 0,
        "avg_latency": 0.0
    }
}

EXPLORATION_RATE = 0.2


# =========================
# FETCH METRICS
# =========================
def fetch_policy_metrics():
    db = SessionLocal()
    try:
        rows = db.execute(text("""
            SELECT policy_id, success_count, failure_count, avg_latency
            FROM policy_metrics
        """)).fetchall()

        metrics_map = {}

        for row in rows:
            total = (row.success_count or 0) + (row.failure_count or 0)

            metrics_map[row.policy_id] = {
                "success_rate": (row.success_count or 0) / max(total, 1),
                "failure_rate": (row.failure_count or 0) / max(total, 1),
                "total_runs": total,
                "avg_latency": float(row.avg_latency or 0.0)
            }

        return metrics_map

    except Exception as e:
        logger.error(f"[METRICS ERROR] {str(e)}", exc_info=True)
        return {}

    finally:
        db.close()


# =========================
# GROUP BY AGENT
# =========================
def group_by_agent(policies):
    grouped = {}
    for p in policies:
        agent = p.get("agent_name", "default")
        grouped.setdefault(agent, []).append(p)
    return grouped


# =========================
# FETCH POLICIES
# =========================
def get_policies(agent_type):
    db = SessionLocal()
    try:
        rows = db.execute(text("""
            SELECT id, agent_type, condition, action, weight
            FROM policies
            WHERE approval_status = 'approved'
        """)).fetchall()

        policies = []
        for r in rows:
            policies.append({
                "id": r.id,
                "agent_type": r.agent_type,
                "condition": r.condition or {},
                "action": r.action or {},
                "weight": r.weight or 1,
                "confidence": 0.5
            })

        return policies

    except Exception as e:
        logger.error(f"[POLICY FETCH ERROR] {str(e)}", exc_info=True)
        return []

    finally:
        db.close()


# =========================
# MAIN POLICY ENGINE
# =========================
def select_policy(agent_type: str, state: dict):
    trace = start_trace()
    increment("policy_engine_calls")

    try:
        # STEP 1: LOAD POLICIES
        policies = get_policies(agent_type)

        if not policies:
            logger.error("No base policies found")
            security_logger.warning("Fallback triggered: no policies available")

            fallback = get_fallback_policy()
            fallback["agent_type"] = agent_type

            return fallback, [fallback]

        # STEP 2: ATTACH METRICS (FIXED)
        metrics_map = fetch_policy_metrics()

        for p in policies:
            p["metrics"] = metrics_map.get(
                p.get("id"),
                {
                    "success_rate": 0.5,
                    "failure_rate": 0.5,
                    "total_runs": 0,
                    "avg_latency": 0.0
                }
            )

        # STEP 3: SCORING
        scored = []

        for p in policies:
            try:
                metrics = p.get("metrics", {})

                score = compute_policy_score(p, metrics)
                weight = p.get("weight", 1.0)

                final_score = (0.7 * score) + (0.3 * weight)

                p["score"] = round(score, 4)
                p["final_score"] = round(final_score, 4)

                scored.append(p)

            except Exception as e:
                logger.error(
                    f"[SCORING ERROR] policy_id={p.get('id')} error={str(e)}",
                    exc_info=True
                )
                security_logger.warning(
                    f"Policy scoring error | policy_id={p.get('id')}"
                )

        if not scored:
            logger.warning("[POLICY ENGINE] Scoring failed → fallback scoring applied")

            for p in policies:
                p["score"] = 0.1
                p["final_score"] = 0.1

            scored = policies

        # STEP 4: GROUPING
        grouped = group_by_agent(scored)

        selected_candidates = []

        for agent, agent_policies in grouped.items():
            best = sorted(
                agent_policies,
                key=lambda x: x.get("final_score", 0),
                reverse=True
            )[0]

            selected_candidates.append(best)

        selected_candidates = sorted(
            selected_candidates,
            key=lambda x: x.get("final_score", 0),
            reverse=True
        )

        best_policy = selected_candidates[0]

        # STEP 5: CONFIDENCE
        confidence = best_policy.get("confidence", 0.5)
        confidence = max(0.1, min(confidence, 1.0))

        # STEP 6: EXPLORATION
        explore = random.random() < EXPLORATION_RATE

        if explore and len(selected_candidates) > 1:
            selected_policy = random.choice(selected_candidates[1:])
            mode = "exploration"
        else:
            selected_policy = best_policy
            mode = "exploitation"

        # STEP 7: LOGGING
        trace = end_trace(trace)

        logger.info({
            "type": "policy_decision",
            "trace_id": trace["trace_id"],
            "duration": trace["duration"],
            "mode": mode,
            "confidence": round(confidence, 4),
            "selected_policy": selected_policy.get("id"),
            "best_policy": best_policy.get("id"),
            "total_candidates": len(selected_candidates)
        })

        return selected_policy, selected_candidates

    except Exception as e:
        logger.error(f"[POLICY ENGINE CRASH] {str(e)}", exc_info=True)
        security_logger.warning("Critical failure in policy engine → fallback activated")

        fallback = get_fallback_policy()
        fallback["agent_type"] = agent_type

        return fallback, [fallback]


def get_fallback_policy():
    return dict(FALLBACK_POLICY)
