from app.db.session import SessionLocal
from sqlalchemy import text
from app.core.logger import logger
import json

from app.core.learning.patterns.pattern_extractor import extract_patterns
from app.core.learning.generators.policy_generator import generate_policies_from_patterns
from app.core.learning.validators.policy_validator import validate_policies
from app.core.learning.pruning.policy_pruner import prune_policies


def run_learning_cycle():
    db = SessionLocal()

    try:
        # =========================
        # STEP 1: PATTERN EXTRACTION
        # =========================
        patterns = extract_patterns()
        logger.info("patterns_extracted", extra={"count": len(patterns)})

        if not patterns:
            logger.info("learning_skipped_no_patterns")
            return

        # =========================
        # STEP 2: POLICY GENERATION
        # =========================
        generated = generate_policies_from_patterns(patterns)
        logger.info("policies_generated", extra={"count": len(generated)})

        if not generated:
            logger.info("learning_skipped_no_generated")
            return

        # =========================
        # STEP 3: VALIDATION
        # =========================
        valid = validate_policies(generated)
        logger.info("policies_validated", extra={"count": len(valid)})

        if not valid:
            logger.info("learning_skipped_no_valid")
            return

        created_count = 0

        # =========================
        # STEP 4: SAFE INSERTION
        # =========================
        for p in valid:

            agent_type = p.get("agent_type")
            action = p.get("action", {})
            condition = p.get("condition", {})
            weight = float(p.get("weight", 1.0))

            # 🔒 VALIDATION GUARD
            if not isinstance(action, dict):
                continue

            if weight <= 0:
                continue

            # 🔁 DUPLICATE CHECK (JSONB SAFE)
            exists = db.execute(text("""
                SELECT 1 FROM policies
                WHERE agent_type = :agent_type
                AND condition::jsonb = CAST(:condition AS JSONB)
                AND action::jsonb = CAST(:action AS JSONB)
                LIMIT 1
            """), {
                "agent_type": agent_type,
                "condition": json.dumps(condition),
                "action": json.dumps(action)
            }).fetchone()

            if exists:
                continue

            # ✅ INSERT POLICY
            db.execute(text("""
                INSERT INTO policies (
                    agent_type,
                    condition,
                    action,
                    weight,
                    approval_status,
                    score,
                    usage_count
                )
                VALUES (
                    :agent_type,
                    :condition,
                    :action,
                    :weight,
                    'approved',
                    :score,
                    :usage_count
                )
            """), {
                "agent_type": agent_type,
                "condition": json.dumps(condition),
                "action": json.dumps(action),
                "weight": weight,
                "score": 0.1,
                "usage_count": 0
            })

            created_count += 1

        # ✅ COMMIT AFTER LOOP
        db.commit()

        # =========================
        # STEP 5: PRUNE (OUTSIDE LOOP)
        # =========================
        prune_policies()

        # =========================
        # STEP 6: LOGGING
        # =========================
        logger.info(
            "learning_cycle_completed",
            extra={
                "patterns": len(patterns),
                "generated": len(generated),
                "valid": len(valid),
                "policies_created": created_count
            }
        )

    except Exception as e:
        db.rollback()

        logger.error(
            "learning_cycle_failed",
            extra={"error": str(e)},
            exc_info=True
        )

    finally:
        db.close()
