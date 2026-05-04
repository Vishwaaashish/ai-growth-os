from sqlalchemy import text

def snapshot_metrics(db, creative_id):
    row = db.execute(text("""
        SELECT ctr, cpa, roas, frequency
        FROM creative_metrics
        WHERE creative_id = :cid
        ORDER BY updated_at DESC
        LIMIT 1
    """), {"cid": creative_id}).fetchone()

    if not row:
        return None

    db.execute(text("""
        INSERT INTO metrics_history (creative_id, ctr, cpa, roas, frequency)
        VALUES (:cid, :ctr, :cpa, :roas, :frequency)
    """), {
        "cid": creative_id,
        "ctr": float(row.ctr or 0),
        "cpa": float(row.cpa or 0),
        "roas": float(row.roas or 0),
        "frequency": float(row.frequency or 0)
    })
    db.commit()

    return {
        "ctr": float(row.ctr or 0),
        "cpa": float(row.cpa or 0),
        "roas": float(row.roas or 0),
        "frequency": float(row.frequency or 0),
    }
