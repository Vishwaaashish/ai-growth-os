from sqlalchemy import text
from app.db.session import get_db


def store_creative_metrics(metrics):
    """
    Store metrics into creative_metrics table
    """

    db = next(get_db())

    for m in metrics:
        db.execute(text("""
            INSERT INTO creative_metrics (
                creative_id, ctr, cpa, roas, frequency, updated_at
            )
            VALUES (
                :creative_id, :ctr, :cpa, :roas, :frequency, NOW()
            )
            ON CONFLICT (creative_id)
            DO UPDATE SET
                ctr = EXCLUDED.ctr,
                cpa = EXCLUDED.cpa,
                roas = EXCLUDED.roas,
                frequency = EXCLUDED.frequency,
                updated_at = NOW()
        """), m)

    db.commit()
