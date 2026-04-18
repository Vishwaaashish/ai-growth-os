def approve_policies(policies):
    for p in policies:
        p["approval_status"] = "approved"
    return policies
