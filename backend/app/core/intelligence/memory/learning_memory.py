from sqlalchemy import text
from app.db.session import SessionLocal


def store_learning_event(policy_id, outcome, latency):
    db = SessionLocal()

    try:
        db.execute(text("""
            INSERT INTO learning_memory (policy_id, outcome, latency)
            VALUES (:pid, :outcome, :latency)
        """), {
            "pid": policy_id,
            "outcome": outcome,
            "latency": latency
        })

        db.commit()

    finally:
        db.close()
