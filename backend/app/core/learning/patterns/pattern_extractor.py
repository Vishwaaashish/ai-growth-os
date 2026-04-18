from app.db.session import SessionLocal
from sqlalchemy import text

def extract_patterns():
    db = SessionLocal()

    try:
        result = db.execute(text("""
            SELECT
                policy_id,
                success_count,
                failure_count,
                avg_latency
            FROM policy_metrics
        """))

        patterns = []

        for row in result:
            total = (row.success_count or 0) + (row.failure_count or 0)

            success_rate = (
                (row.success_count or 0) / total if total > 0 else 0
            )

            patterns.append({
                "policy_id": row.policy_id,
                "success_rate": success_rate,
                "avg_latency": float(row.avg_latency or 0),
                "total_runs": total
            })

        return patterns   # ✅ LIST (CRITICAL FIX)

    finally:
        db.close()


