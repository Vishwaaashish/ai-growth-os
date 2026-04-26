def reason(plan, memory):
    """
    Convert plan → decisions compatible with strategy_selector
    """

    decisions = []

    # SAFETY: ensure dict
    if not isinstance(memory, dict):
        memory = {}

    avg_latency = memory.get("avg_latency", 0)

    for step in plan:

        decision = "default"

        # =========================
        # EXISTING SYSTEM MAPPING
        # =========================
        if step.get("strategy") == "optimize_latency":
            decision = "exploit"

        elif step.get("strategy") == "maximize_success":
            decision = "explore"

        # =========================
        # 🔥 FIX 1: MEMORY CONDITION
        # =========================
        # 🔒 CONTROLLED CREATIVE TRIGGER
        creative_threshold = 1100

        if avg_latency > creative_threshold:
            decision = "creative_needed"

        # Prevent continuous generation
        elif memory.get("last_strategy") == "generate_creative":
            decision = "explore"

        # =========================
        # 🔥 FIX 2: FALLBACK TRIGGER
        # =========================
        # If system is exploring → force creative generation
        elif decision == "explore":
            decision = "creative_needed"

        decisions.append({
            "goal_id": step.get("goal_id"),
            "decision": decision
        })

    return decisions
