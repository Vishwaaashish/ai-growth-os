from sqlalchemy import text
from datetime import datetime, timezone
from app.services.policy_smoothing import ema_update

def update_policy(db, policy_id, reward):
    row = db.execute(text("""
        SELECT score FROM policies WHERE id = :pid
    """), {"pid": policy_id}).fetchone()

    if not row:
        return

    old_score = float(row.score or 0)
    new_score = ema_update(old_score, reward)

    db.execute(text("""
        UPDATE policies
        SET score = :score,
            usage_count = usage_count + 1,
            last_used = :ts
        WHERE id = :pid
    """), {
        "score": new_score,
        "ts": datetime.now(timezone.utc),
        "pid": policy_id
    })
    db.commit()
