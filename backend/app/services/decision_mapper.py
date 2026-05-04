from app.core.logger import logger
from app.decision_engine import decide


def map_decision_to_action(policy, confidence, metrics):
    """
    STRICT CONTRACT:
    ALWAYS RETURNS:
    {
        action: str,
        decision: str,
        confidence: float
    }
    """

    try:
        ctr = float(metrics.get("ctr", 0))
        roas = float(metrics.get("roas", 0))
        cpa = float(metrics.get("cpa", 0))

        # =========================
        # CORE DECISION ENGINE
        # =========================
        action, reason = decide(
            ctr=ctr,
            roas=roas,
            cpa=cpa,
            confidence=confidence
        )

        logger.info("decision_mapped", extra={
            "ctr": ctr,
            "roas": roas,
            "cpa": cpa,
            "action": action,
            "reason": reason,
            "confidence": confidence
        })

        return {
            "action": action,
            "decision": reason,
            "confidence": confidence
        }

    except Exception as e:
        logger.error("decision_mapper_error", extra={"error": str(e)})

        # 🔴 FAILSAFE (CRITICAL)
        return {
            "action": "test",
            "decision": "insufficient_data",
            "confidence": 0.0
        }
