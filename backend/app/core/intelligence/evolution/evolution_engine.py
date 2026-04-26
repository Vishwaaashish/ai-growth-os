from app.core.logger import logger
from sqlalchemy import text
from app.db.session import SessionLocal

from app.core.learning.patterns.pattern_extractor import extract_patterns
from app.core.learning.generators.policy_generator import generate_policies_from_patterns
from app.core.learning.validators.policy_validator import validate_policies


def evolve_policies():
    db = SessionLocal()

    try:
        # =========================
        # STEP 1: EXTRACT PATTERNS
        # =========================
        patterns = extract_patterns()

        if not patterns:
            logger.info("no_patterns_found")
            return {"created": 0}

        # =========================
        # STEP 2: GENERATE POLICIES
        # =========================
        candidates = generate_policies_from_patterns(patterns)

        # =========================
        # STEP 3: VALIDATE
        # =========================
        valid_policies = validate_policies(candidates)

        created = 0

        # =========================
        # STEP 4: INSERT NEW POLICIES
        # =========================
        for p in valid_policies:

            db.execute(text("""
                INSERT INTO policies (
                    id,
                    agent_type,
                    condition,
                    action,
                    weight,
                    approval_status
                )
                VALUES (
                    gen_random_uuid(),
                    :agent_type,
                    :condition,
                    :action,
                    :weight,
                    'approved'
                )
            """), {
                "agent_type": p["agent_type"],
                "condition": str(p["condition"]),
                "action": str(p["action"]),
                "weight": p["weight"]
            })

            created += 1

        # =========================
        # STEP 5: UPDATE EXISTING POLICIES (EVOLUTION)
        # =========================
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

        logger.info("evolution_cycle", extra={
            "patterns": len(patterns),
            "generated": len(candidates),
            "valid": len(valid_policies),
            "created": created
        })

        return {"created": created}

    except Exception as e:
        logger.error(
            "evolution_error",
            extra={"error": str(e)},
            exc_info=True
        )
        db.rollback()
        return {"created": 0}

    finally:
        db.close()






