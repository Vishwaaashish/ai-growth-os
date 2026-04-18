def validate_policy(policy):
    # weight bounds
    if policy.get("weight", 0) < 0 or policy.get("weight", 0) > 5:
        return False

    # priority bounds
    priority = policy.get("action", {}).get("priority", 0)
    if priority < 1 or priority > 10:
        return False

    return True
