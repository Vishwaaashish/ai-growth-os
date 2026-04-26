from sqlalchemy import text
from app.db.session import SessionLocal

def detect_fatigue():
    db = SessionLocal()

    fatigued = []

    try:
        results = db.execute(text("""
            SELECT cm.creative_id, cm.ctr, cm.cpa, cm.frequency
            FROM creative_metrics cm
            JOIN creatives c ON c.id = cm.creative_id::uuid
            WHERE c.status = 'generated'
        """)).fetchall()

        for r in results:
            ctr = r.ctr or 0
            cpa = r.cpa or 0
            freq = r.frequency or 0

            if ctr < 1.0 and freq > 2.5 and cpa > 150:
                fatigued.append(r.creative_id)

        return fatigued

    finally:
        db.close()
