from sqlalchemy import text
from app.db.session import SessionLocal

def optimize_long_term():
    db = SessionLocal()

    try:
        db.execute(text("""
            UPDATE policies
            SET weight = weight + 0.2
            WHERE id IN (
                SELECT policy_id
                FROM strategy_memory
                WHERE success = true
                GROUP BY policy_id
                HAVING COUNT(*) > 5
            )
        """))

        db.commit()

    finally:
        db.close()
