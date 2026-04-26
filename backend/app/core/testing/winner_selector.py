from sqlalchemy import text
from app.db.session import SessionLocal

def select_winner():
    db = SessionLocal()

    try:
        result = db.execute(text("""
            SELECT creative_id
            FROM creative_metrics
            ORDER BY 
                roas DESC,
                ctr DESC,
                cpa ASC
            LIMIT 1
        """)).fetchone()

        if result:
            return result.creative_id

        return None

    finally:
        db.close()
