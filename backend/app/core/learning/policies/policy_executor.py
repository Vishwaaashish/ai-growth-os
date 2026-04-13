def apply_policy(job, policy):
    """
    Converts policy → execution instructions
    """

    if not policy:
        return {
            "queue": "default",
            "retry": True,
            "priority": "normal"
        }

    action = policy.get("recommended_action", {})

    return {
        "queue": action.get("priority", "default"),
        "retry": action.get("retry", True),
        "priority": action.get("priority", "normal")
    }
