def decide_action(ctr, roas, cpa, confidence):
    # =========================
    # BASE THRESHOLDS (TUNE LATER)
    # =========================
    if confidence < 0.2:
        return "test"

    if roas > 3 and ctr > 1.5:
        return "scale"

    if roas < 1 or cpa > 300:
        return "pause"

    return "test"
