from sqlalchemy import text
from datetime import datetime

def log_action(db, creative_id, decision):

    # ✅ MAP ACTION
    if decision == "scale":
        action = "scale_creative"
    elif decision == "kill":
        action = "pause_creative"
    else:
        action = "no_action"

    # ✅ STEP 1: CHECK EXISTING (LAST 1 HOUR)
    existing = db.execute(text("""
        SELECT 1 FROM action_logs
        WHERE creative_id = :cid
        AND decision = :decision
        AND timestamp > NOW() - INTERVAL '1 hour'
        LIMIT 1
    """), {
        "cid": creative_id,
        "decision": decision
    }).fetchone()

    # ✅ STEP 2: INSERT ONLY IF NOT EXISTS
    if not existing:
        db.execute(text("""
            INSERT INTO action_logs (creative_id, action, decision, timestamp)
            VALUES (:creative_id, :action, :decision, :timestamp)
        """), {
            "creative_id": creative_id,
            "action": action,
            "decision": decision,
            "timestamp": datetime.utcnow()
        })

        db.commit()
