def validate_policies(policies):
    valid = []

    for p in policies:
        if not isinstance(p, dict):
            continue

        if "action" not in p:
            continue

        if not isinstance(p["action"], dict):
            continue

        if "priority" not in p["action"]:
            continue

        if "weight" not in p:
            continue

        if p["weight"] <= 0:
            continue

        valid.append(p)

    return valid
