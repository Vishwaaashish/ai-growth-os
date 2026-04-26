from app.db.session import SessionLocal
from sqlalchemy import text

def optimize_from_feedback(policy_id, success, latency):

    db = SessionLocal()

    try:
        db.execute(text("""
            INSERT INTO feedback_log (policy_id, success, latency)
            VALUES (:policy_id, :success, :latency)
        """), {
            "policy_id": policy_id,
            "success": success,
            "latency": latency
        })

        db.commit()

    finally:
        db.close()
