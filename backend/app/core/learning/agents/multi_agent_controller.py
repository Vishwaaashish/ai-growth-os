def evaluate_agents(plan, memory):
    agent_outputs = []

    for step in plan:
        agent = step.get("agent")

        if agent == "efficiency":
            score = 1 / (step.get("latency", 1) + 1)

        elif agent == "reliability":
            score = step.get("success_rate", 0)

        elif agent == "explorer":
            score = 0.5  # exploration bias

        else:
            score = 0.1

        agent_outputs.append({
            "agent": agent,
            "score": score
        })

    return sorted(agent_outputs, key=lambda x: x["score"], reverse=True)
