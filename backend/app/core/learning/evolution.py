
from sqlalchemy import text
from app.db.session import SessionLocal
from app.core.logger import logger



# 🔷 THRESHOLDS (TUNABLE)
SUCCESS_THRESHOLD = 0.6
FAILURE_THRESHOLD = 0.4
MIN_RUNS = 1


def evolve_policies():
    db = SessionLocal()

    try:
        rows = db.execute(text("""
            SELECT policy_id, success_count, failure_count
            FROM policy_metrics
        """)).fetchall()

        for row in rows:
            policy_id = row.policy_id
            success = row.success_count or 0
            failure = row.failure_count or 0

            total = success + failure

            if total < MIN_RUNS:
                continue  # not enough data

            success_rate = success / total

            # 🔷 CASE 1: HIGH PERFORMER → BOOST
            if success_rate >= SUCCESS_THRESHOLD:
                db.execute(text("""
                    UPDATE policies
                    SET weight = LEAST(weight + 0.2, 5)
                    WHERE id = :policy_id
                """), {"policy_id": policy_id})

                logger.info(
                    "policy_boost",
                    extra={
                        "policy_id": policy_id,
                        "success_rate": success_rate
                    }
                )


            # 🔷 CASE 2: LOW PERFORMER → PENALIZE
            elif success_rate <= FAILURE_THRESHOLD:
                db.execute(text("""
                    UPDATE policies
                    SET weight = GREATEST(weight - 0.3, 0.1)
                    WHERE id = :policy_id
                """), {"policy_id": policy_id})

                logger.info(
                    "policy_penalty",
                    extra={
                        "policy_id": policy_id,
                        "success_rate": success_rate
                    }
                )

            # 🔷 CASE 3: DEAD POLICY → DISABLE
            if failure >= 10:
                db.execute(text("""
                    UPDATE policies
                    SET approval_status = 'rejected'
                    WHERE id = :policy_id
                """), {"policy_id": policy_id})

                logger.warning(
                    "policy_disabled",
                    extra={
                        "policy_id": policy_id
                    }
                )

        db.commit()

    except Exception as e:

        logger.error(
            "evolution_error",
            extra={"error": str(e)},
            exc_info=True
        )
        db.rollback()

    finally:
        db.close()
