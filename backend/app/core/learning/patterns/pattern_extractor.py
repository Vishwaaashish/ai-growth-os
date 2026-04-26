from app.db.session import SessionLocal
from sqlalchemy import text

def extract_patterns():
    db = SessionLocal()

    try:
        result = db.execute(text("""
            SELECT
                campaign_id,
                ctr,
                cpa
            FROM campaign_metrics
        """))

        patterns = []

        for row in result:

            success_rate = float(row.ctr or 0)
            avg_latency = float(row.cpa or 0)

            # 🔥 PATTERN CLASSIFICATION
            if success_rate > 0.06:
                pattern_type = "high_success"
            elif success_rate < 0.02:
                pattern_type = "high_failure"
            else:
                pattern_type = "neutral"

            patterns.append({
                "policy_id": row.campaign_id,   # ⚠️ reuse field
                "success_rate": success_rate,
                "avg_latency": avg_latency,
                "total_runs": 1,
                "pattern": pattern_type
            })

        return patterns

    finally:
        db.close()



