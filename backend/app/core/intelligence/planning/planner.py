def build_plan(goals, context):

    plan = []

    for goal in goals:
        plan.append({
            "goal_id": goal["id"],
            "strategy": "optimize_latency" if "latency" in goal["target_metric"] else "maximize_success",
            "priority": goal["priority"]
        })

    return sorted(plan, key=lambda x: x["priority"], reverse=True)
