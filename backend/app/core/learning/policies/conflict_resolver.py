def resolve_conflicts(policies, context):
    if not policies:
        return []

    # remove invalid
    valid = [p for p in policies if p.get("action")]

    # remove duplicates
    unique = {p["id"]: p for p in valid}.values()

    return list(unique)
