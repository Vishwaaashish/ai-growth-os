import random
from sqlalchemy import text

from app.core.logger import logger
from app.core.logger import logger as security_logger

from app.core.observability.metrics import increment
from app.core.observability.trace import start_trace, end_trace

from app.core.learning.policies.scoring import compute_policy_score
from app.db.session import SessionLocal


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
        logger.error(
            "metrics_fetch_error",
            extra={"error": str(e)},
            exc_info=True
        )
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
        logger.error(
            "policy_fetch_error",
            extra={"error": str(e)},
            exc_info=True
        )
        return []

    finally:
        db.close()


# =========================
# MAIN POLICY ENGINE
# =========================
def select_policy(agent_type: str, state: dict):
    trace = start_trace()
    increment("policy_engine_calls", "global")

    try:
        policies = get_policies(agent_type)

        if not policies:
            logger.error("no_base_policies_found", extra={})
            security_logger.warning(
                "fallback_triggered_no_policies",
                extra={}
            )

            fallback = get_fallback_policy()
            fallback["agent_type"] = agent_type

            return fallback, [fallback]

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
                    "policy_scoring_error",
                    extra={
                        "policy_id": p.get("id"),
                        "error": str(e)
                    },
                    exc_info=True
                )
                security_logger.warning(
                    "policy_scoring_warning",
                    extra={"policy_id": p.get("id")}
                )

        if not scored:
            logger.warning(
                "scoring_failed_fallback_applied",
                extra={}
            )

            for p in policies:
                p["score"] = 0.1
                p["final_score"] = 0.1

            scored = policies

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

        confidence = best_policy.get("confidence", 0.5)
        confidence = max(0.1, min(confidence, 1.0))

        explore = random.random() < EXPLORATION_RATE

        if explore:
            weights = [
                max(p.get("score", 0.1), 0.1)
                for p in selected_candidates
            ]

            selected_policy = random.choices(
                selected_candidates,
                weights=weights,
                k=1
            )[0]

            mode = "exploration"

        else:
            selected_policy = best_policy
            mode = "exploitation"

        trace = end_trace(trace)

        logger.info(
            "policy_decision",
            extra={
                "trace_id": trace["trace_id"],
                "duration": trace["duration"],
                "mode": mode,
                "confidence": round(confidence, 4),
                "selected_policy": selected_policy.get("id"),
                "best_policy": best_policy.get("id"),
                "total_candidates": len(selected_candidates)
            }
        )

        return selected_policy, selected_candidates

    except Exception as e:
        logger.error(
            "policy_engine_crash",
            extra={"error": str(e)},
            exc_info=True
        )
        security_logger.warning(
            "policy_engine_fallback_triggered",
            extra={}
        )

        fallback = get_fallback_policy()
        fallback["agent_type"] = agent_type

        return fallback, [fallback]


def get_fallback_policy():
    return dict(FALLBACK_POLICY)
