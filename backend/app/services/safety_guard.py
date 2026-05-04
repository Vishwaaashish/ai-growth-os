from app.core.logger import logger


# =========================
# GLOBAL SAFETY CONFIG
# =========================
SAFETY_CONFIG = {
    "min_confidence": 0.2,
    "max_scale_percent": 20,
    "max_cpa": 200,
    "min_roas": 1.5,
    "kill_switch": False,
}


def validate_action(decision, metrics, confidence):
    """
    Validate AI decision before execution
    """

    # =========================
    # KILL SWITCH
    # =========================
    if SAFETY_CONFIG["kill_switch"]:
        return block("kill_switch_active")

    ctr = metrics.get("ctr", 0)
    roas = metrics.get("roas", 0)
    cpa = metrics.get("cpa", 0)

    # =========================
    # CONFIDENCE GUARD
    # =========================
    if decision == "scale" and confidence < SAFETY_CONFIG["min_confidence"]:
        return block("low_confidence")

    # =========================
    # CPA PROTECTION
    # =========================
    if cpa > SAFETY_CONFIG["max_cpa"]:
        return override("pause", "high_cpa")

    # =========================
    # ROAS PROTECTION
    # =========================
    if decision == "scale" and roas < SAFETY_CONFIG["min_roas"]:
        return block("low_roas")

    # =========================
    # SAFE PASS
    # =========================
    return {
        "approved": True,
        "final_action": decision,
        "reason": "validated"
    }


def block(reason):
    logger.warning(f"[SAFETY BLOCK] {reason}")

    return {
        "approved": False,
        "final_action": "hold",
        "reason": reason
    }


def override(new_action, reason):
    logger.warning(f"[SAFETY OVERRIDE] {reason}")

    return {
        "approved": True,
        "final_action": new_action,
        "reason": reason
    }
