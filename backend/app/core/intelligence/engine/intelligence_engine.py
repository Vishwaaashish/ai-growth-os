def decide(context, memory):
    """
    Phase 2 basic intelligence (rule + memory weighted)
    """

    if not memory:
        return {"strategy": "default"}

    success_rate = sum(1 for m in memory if m["outcome"]) / len(memory)

    if success_rate > 0.7:
        return {"strategy": "exploit"}
    else:
        return {"strategy": "explore"}
