from sqlalchemy import text
from app.db.session import SessionLocal

def start_experiment(creative_id, variants=3):
    db = SessionLocal()

    try:
        for i in range(variants):
            db.execute(text("""
                INSERT INTO experiments (creative_id, variant, status)
                VALUES (:creative_id, :variant, 'running')
            """), {
                "creative_id": creative_id,
                "variant": f"v{i+1}"
            })

        db.commit()

    finally:
        db.close()
