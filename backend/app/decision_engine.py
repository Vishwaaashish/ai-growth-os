from app.core.logger import logger
from app.core.infra_manager import InfraManager
from app.core.learning.policies.scoring import compute_policy_score
from app.core.learning.policies.policy_engine import get_fallback_policy


# =========================================================
# 🔷 INFRA DECISION ENGINE (SYSTEM ACTIONS)
# =========================================================
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


decision_engine = DecisionEngine()


# =========================================================
# 🔷 POLICY SELECTION (SCORING)
# =========================================================
def select_best_policy(policies):
    if not policies:
        fallback = get_fallback_policy()
        return fallback, [fallback]

    scored = []

    for p in policies:
        metrics = p.get("metrics", {})

        logger.debug("policy_input", extra={"data": p})
        logger.debug("extracted_metrics", extra={"data": metrics})

        score = compute_policy_score(p, metrics)

        p["score"] = round(score, 4)
        scored.append(p)

    ranked = sorted(scored, key=lambda x: x.get("score", 0), reverse=True)

    return ranked[0], ranked


def apply_priority_arbitration(policies):
    if not policies:
        return get_fallback_policy()

    high_priority = [p for p in policies if p.get("priority", 0) >= 9]

    if high_priority:
        return sorted(high_priority, key=lambda x: x.get("priority", 0), reverse=True)[0]

    return get_fallback_policy()


# =========================================================
# 🔷 PHASE 4.0 — DECISION ENGINE (MARKETING)
# =========================================================

def map_decision(action):
    """
    Deterministic decision mapping (NO ambiguity)
    """
    mapping = {
        "scale": "high_performance",
        "pause": "low_performance",
        "optimize": "needs_improvement",
        "test": "insufficient_data"
    }
    return mapping.get(action, "unknown")

# =========================================================
# 🔷 UNIFIED DECISION ENGINE (STRICT CONTRACT)
# =========================================================

def decide(ctr, roas, cpa, confidence):
    """
    ALWAYS RETURNS:
    (action, reason)
    """

    # =========================
    # LOW CONFIDENCE → FORCE TEST
    # =========================
    if confidence < 0.3:
        return "test", "insufficient_data"

    # =========================
    # HIGH PERFORMANCE
    # =========================
    if roas >= 3 and cpa <= 100:
        return "scale", "high_performance"

    # =========================
    # MEDIUM PERFORMANCE
    # =========================
    if roas >= 2:
        return "optimize", "needs_improvement"

    # =========================
    # LOW PERFORMANCE
    # =========================
    return "pause", "low_performance"


# =========================================================
# 🔷 ASYNC WRAPPERS (AGENTS)
# =========================================================
async def scale_up(context):
    return decision_engine.scale_up()


async def restart_failed_jobs(context):
    return decision_engine.restart_worker()


async def optimize_performance(context):
    return decision_engine.optimize_latency()


# =========================================================
# 🔷 TEST BLOCK
# =========================================================
if __name__ == "__main__":
    test = make_decision(ctr=1.2, roas=2.8, cpa=90, confidence=0.7)

    logger.info("decision_test", extra=test)
