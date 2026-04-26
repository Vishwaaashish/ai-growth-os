from app.core.logger import logger
from sqlalchemy import text
from app.db.session import SessionLocal


def extract_patterns():
    db = SessionLocal()

    try:
        rows = db.execute(text("""
            SELECT policy_id, success_count, failure_count, avg_latency
            FROM policy_metrics
        """)).fetchall()

        patterns = []

        for r in rows:
            total = r.success_count + r.failure_count
            if total < 5:
                continue

            success_rate = r.success_count / total

            if success_rate > 0.8:
                pattern_type = "high_success"
            elif success_rate < 0.3:
                pattern_type = "high_failure"
            else:
                pattern_type = "neutral"

            patterns.append({
                "policy_id": r.policy_id,
                "pattern": pattern_type,
                "confidence": success_rate,
                "latency": r.avg_latency
            })

        return patterns

    except Exception as e:
        logger.error(
            "pattern_extraction_error",
            extra={"error": str(e)},
            exc_info=True
        )
        return []

    finally:
        db.close()
