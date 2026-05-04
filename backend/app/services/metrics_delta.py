from sqlalchemy import text

WINDOW_MINUTES = 60  # start with 60; tune later

def get_before_after(db, creative_id):
    # latest (after)
    after = db.execute(text("""
        SELECT ctr, cpa, roas, frequency
        FROM metrics_history
        WHERE creative_id = :cid
        ORDER BY captured_at DESC
        LIMIT 1
    """), {"cid": creative_id}).fetchone()

    # baseline (before) at window start
    before = db.execute(text(f"""
        SELECT ctr, cpa, roas, frequency
        FROM metrics_history
        WHERE creative_id = :cid
          AND captured_at <= NOW() - INTERVAL '{WINDOW_MINUTES} minutes'
        ORDER BY captured_at DESC
        LIMIT 1
    """), {"cid": creative_id}).fetchone()

    if not after or not before:
        return None, None

    return (
        {
            "ctr": float(before.ctr or 0),
            "cpa": float(before.cpa or 0),
            "roas": float(before.roas or 0),
            "frequency": float(before.frequency or 0),
        },
        {
            "ctr": float(after.ctr or 0),
            "cpa": float(after.cpa or 0),
            "roas": float(after.roas or 0),
            "frequency": float(after.frequency or 0),
        }
    )
