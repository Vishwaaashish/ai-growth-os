from app.core.logger import logger
from app.core.infra_manager import InfraManager
from app.core.learning.policies.scoring import compute_policy_score
from app.core.learning.policies.policy_engine import get_fallback_policy


# 🔷 CORE DECISION ENGINE (INFRA ACTIONS)
class DecisionEngine:
    def __init__(self):
        self.infra = InfraManager()

    def scale_up(self):
        try:
            self.infra.scale(2)
            return {"action": "scale_up"}
        except Exception as e:
            return {"error": str(e)}

    def restart_worker(self):
        try:
            self.infra.restart()
            return {"action": "restart_worker"}
        except Exception as e:
            return {"error": str(e)}

    def optimize_latency(self):
        try:
            self.infra.optimize_cpu()
            containers = self.infra.get_worker_containers()
            return {
                "action": "optimize_latency",
                "containers": containers,
            }
        except Exception as e:
            return {"error": str(e)}


# 🔷 POLICY DECISION LAYER (PHASE 6.4)

def select_best_policy(policies):
    """
    Weighted scoring selection
    """
    if not policies:

        fallback = get_fallback_policy()
        return fallback, [fallback]

    scored = []

    for p in policies:
        metrics = p.get("metrics", {})  # SAFE EXTRACTION

        logger.debug("policy_input", extra={"data": p})
        logger.debug("extracted_metrics", extra={"data": p.get("metrics")})

        score = compute_policy_score(p, metrics)

        # attach score
        p["score"] = round(score, 4)

        scored.append(p)

    ranked = sorted(
        scored,
        key=lambda x: x.get("score", 0),
        reverse=True
    )

    return ranked[0], ranked


def apply_priority_arbitration(policies):
    """
    Priority override layer
    """
    if not policies:

        return get_fallback_policy()

    high_priority = [
        p for p in policies if p.get("priority", 0) >= 9
    ]

    if high_priority:
        return sorted(
            high_priority,
            key=lambda x: x.get("priority", 0),
            reverse=True
        )[0]

    return get_fallback_policy()


# 🔷 SINGLE INSTANCE (SYSTEM WIDE)
decision_engine = DecisionEngine()


# 🔷 ASYNC WRAPPERS (AGENT INTERFACE)

async def scale_up(context):
    return decision_engine.scale_up()


async def restart_failed_jobs(context):
    return decision_engine.restart_worker()


async def optimize_performance(context):
    return decision_engine.optimize_latency()


if __name__ == "__main__":
    test_policies = [
        {
            "id": "policy_high_success",
            "priority": 5,
            "metrics": {
                "success_rate": 0.9,
                "failure_count": 1,
                "total_runs": 10,
                "avg_latency": 100
            }
        },
        {
            "id": "policy_high_failure",
            "priority": 5,
            "metrics": {
                "success_rate": 0.3,
                "failure_count": 7,
                "total_runs": 10,
                "avg_latency": 500
            }
        }
    ]

    best, ranked = select_best_policy(test_policies)

    logger.info("final_output", extra={
        "best_policy": best,
        "ranked": ranked
    })
