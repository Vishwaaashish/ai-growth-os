from app.db.session import SessionLocal
from sqlalchemy import text

def get_active_goals():
    db = SessionLocal()
    try:
        result = db.execute(text("""
            SELECT id, name, priority, target_metric
            FROM system_goals
            WHERE is_active = TRUE
            ORDER BY priority DESC
        """))

        return [dict(row._mapping) for row in result]

    finally:
        db.close()
