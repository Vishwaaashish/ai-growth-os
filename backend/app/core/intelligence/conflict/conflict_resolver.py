def resolve_conflict(agent_rankings):
    if not agent_rankings:
        return "fallback"

    top = agent_rankings[0]
    second = agent_rankings[1] if len(agent_rankings) > 1 else None

    if second and abs(top["score"] - second["score"]) < 0.1:
        return "balanced"

    return top["agent"]
