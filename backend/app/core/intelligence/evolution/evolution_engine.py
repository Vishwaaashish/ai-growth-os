import logging
from sqlalchemy import text
from app.db.session import SessionLocal
from app.core.intelligence.patterns.pattern_engine import extract_patterns

logger = logging.getLogger(__name__)


def evolve_policies():
    db = SessionLocal()

    try:
        patterns = extract_patterns()

        for p in patterns:

            if p["pattern"] == "high_success":
                db.execute(text("""
                    UPDATE policies
                    SET weight = LEAST(weight + 0.5, 5)
                    WHERE id = :pid
                """), {"pid": p["policy_id"]})

            elif p["pattern"] == "high_failure":
                db.execute(text("""
                    UPDATE policies
                    SET weight = GREATEST(weight - 0.5, 0.1)
                    WHERE id = :pid
                """), {"pid": p["policy_id"]})

        db.commit()

        logger.info("Policy evolution completed")

    except Exception as e:
        logger.error(f"Evolution Error: {str(e)}")
        db.rollback()

    finally:
        db.close()
