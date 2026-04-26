import time

from app.db.session import SessionLocal
from sqlalchemy import text
from app.core.logger import logger

def update_policy_metrics(policy_id, success, latency=0):
    db = SessionLocal()

    try:
        if success:
            db.execute(text("""
                INSERT INTO policy_metrics (policy_id, success_count, failure_count, avg_latency)
                VALUES (:policy_id, 1, 0, :latency)
                ON CONFLICT (policy_id)
                DO UPDATE SET
                    success_count = policy_metrics.success_count + 1,
                    avg_latency = (policy_metrics.avg_latency + :latency) / 2
            """), {
                "policy_id": policy_id,
                "latency": latency
            })

        else:
            db.execute(text("""
                INSERT INTO policy_metrics (policy_id, success_count, failure_count, avg_latency)
                VALUES (:policy_id, 0, 1, 0)
                ON CONFLICT (policy_id)
                DO UPDATE SET
                    failure_count = policy_metrics.failure_count + 1
            """), {
                "policy_id": policy_id
            })

        db.commit()

    except Exception as e:

        logger.error(
            "metrics_update_failed",
            extra={"error": str(e)},
            exc_info=True
        )
        db.rollback()

    finally:
        db.close()
