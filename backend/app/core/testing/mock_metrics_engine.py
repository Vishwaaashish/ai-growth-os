import random
from sqlalchemy import text
from app.db.session import SessionLocal


def update_mock_metrics():
    db = SessionLocal()

    try:
        creatives = db.execute(text("""
            SELECT id FROM creatives WHERE status = 'generated'
        """)).fetchall()

        for c in creatives:
            db.execute(text("""
                INSERT INTO creative_metrics (
                    creative_id,
                    ctr,
                    cpa,
                    roas,
                    frequency,
                    updated_at
                )
                VALUES (
                    :creative_id,
                    :ctr,
                    :cpa,
                    :roas,
                    :frequency,
                    NOW()
                )
            """), {
                "creative_id": c[0],
                "ctr": round(random.uniform(0.5, 3.5), 2),
                "cpa": round(random.uniform(50, 300), 2),
                "roas": round(random.uniform(1.0, 4.0), 2),
                "frequency": round(random.uniform(1.0, 3.0), 2)
            })

        db.commit()

    finally:
        db.close()
