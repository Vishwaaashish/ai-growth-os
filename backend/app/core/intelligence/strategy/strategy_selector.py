def select_final_strategy(decisions):

    if not decisions:
        return "balanced"

    decision_set = {d.get("decision") for d in decisions}

    # 🔥 PRIORITY 1 — CREATIVE (ABSOLUTE)
    if "creative_needed" in decision_set:
        return "generate_creative"

    # 🔥 PRIORITY 2 — SCALE
    if "exploit" in decision_set:
        return "scale"

    # 🔥 PRIORITY 3 — SAFE MODE
    if "explore" in decision_set:
        return "balanced"

    return "balanced"
