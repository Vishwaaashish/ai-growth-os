from app.db.session import SessionLocal
from sqlalchemy import text
from app.core.logger import logger


def prune_policies():

    db = SessionLocal()

    try:
        # 🔴 RULE 1: Remove very low score policies
        low_score_deleted = db.execute(text("""
            DELETE FROM policies
            WHERE score < -5
        """)).rowcount

        # 🔴 RULE 2: Remove unused policies (stale)
        stale_deleted = db.execute(text("""
            DELETE FROM policies
            WHERE usage_count = 0
            AND created_at < NOW() - INTERVAL '1 hour'
        """)).rowcount

        # 🔴 RULE 3: Keep only top N policies
        max_policies = 50

        db.execute(text(f"""
            DELETE FROM policies
            WHERE id NOT IN (
                SELECT id FROM policies
                ORDER BY score DESC NULLS LAST
                LIMIT {max_policies}
            )
        """))

        db.commit()

        logger.info("policy_pruning_completed", extra={
            "low_score_deleted": low_score_deleted,
            "stale_deleted": stale_deleted,
            "max_limit": max_policies
        })

    except Exception as e:
        db.rollback()
        logger.error("policy_pruning_failed", extra={"error": str(e)})

    finally:
        db.close()
