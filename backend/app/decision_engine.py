import logging
from app.core.infra_manager import InfraManager
from app.core.learning.policies.scoring import compute_policy_score

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


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
        return None, []

    scored = []

    for p in policies:
        score = compute_policy_score(p)

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
        return None

    high_priority = [
        p for p in policies if p.get("priority", 0) >= 9
    ]

    if high_priority:
        return sorted(
            high_priority,
            key=lambda x: x.get("priority", 0),
            reverse=True
        )[0]

    return None


# 🔷 SINGLE INSTANCE (SYSTEM WIDE)
decision_engine = DecisionEngine()


# 🔷 ASYNC WRAPPERS (AGENT INTERFACE)

async def scale_up(context):
    return decision_engine.scale_up()


async def restart_failed_jobs(context):
    return decision_engine.restart_worker()


async def optimize_performance(context):
    return decision_engine.optimize_latency()
