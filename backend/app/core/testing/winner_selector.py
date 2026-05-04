def select_winner(creatives):
    """
    Accepts:
        - list of strings (creative_ids)
        - list of dicts (structured creatives)

    Always returns:
        - dict with creative_id, ctr, roas, cpa
    """

    if not creatives:
        return None

    normalized = []

    for c in creatives:
        # CASE 1: already structured
        if isinstance(c, dict):
            normalized.append({
                "creative_id": c.get("creative_id") or c.get("id"),
                "ctr": float(c.get("ctr", 0)),
                "roas": float(c.get("roas", 0)),
                "cpa": float(c.get("cpa", 0)),
            })

        # CASE 2: string → convert safely
        else:
            normalized.append({
                "creative_id": str(c),
                "ctr": 0.0,
                "roas": 0.0,
                "cpa": 0.0,
            })

    def score(c):
        ctr = c["ctr"]
        roas = c["roas"]
        cpa = c["cpa"]

        # NORMALIZATION FIX (CRITICAL)
        normalized_cpa = cpa / 100

        return (ctr * 0.4) + (roas * 0.4) - (normalized_cpa * 0.2)

    best = sorted(normalized, key=score, reverse=True)[0]

    print(f"[WINNER] Selected creative: {best['creative_id']}")

    return best
