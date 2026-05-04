def calculate_reward(before, after):
    """
    Reward = ROAS gain - CPA penalty (normalized)
    """
    roas_delta = after["roas"] - before["roas"]
    cpa_delta = before["cpa"] - after["cpa"]  # positive if CPA decreased

    # weights (tune later)
    return (roas_delta * 1.0) + (cpa_delta * 0.01)
