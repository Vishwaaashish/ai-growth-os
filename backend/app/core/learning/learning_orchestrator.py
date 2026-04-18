from app.db.session import SessionLocal
from sqlalchemy import text
import logging
import json

from app.core.security.policy_guard import validate_policy

from app.core.learning.patterns.pattern_extractor import extract_patterns
from app.core.learning.generators.policy_generator import generate_policies_from_patterns
from app.core.learning.validators.policy_validator import validate_policies

from app.core.learning.approvals.approval_manager import approve_policies
from app.core.learning.evolution import evolve_policies

#def save_policies_to_db(policies):
#    db = SessionLocal()

#    try:
#        for p in policies:

            # 🔴 PREVENT DUPLICATES
#            exists = db.execute(text(""")
#                SELECT 1 FROM policies
#                WHERE agent_type = :agent_type
#                AND action::jsonb = :action::jsonb
#                LIMIT 1
#            """), {
#                "agent_type": p["agent_type"],
#                "action": json.dumps(p["action"])
#            }).fetchone()

#            if exists:
#                continue

#            db.execute(text(""")
#                INSERT INTO policies (agent_type, condition, action, weight, approval_status)
#                VALUES (:agent_type, :condition, :action, :weight, :approval_status)
#            """), {
#                "agent_type": p["agent_type"],
#                "agent_name": p["agent_name"],
#                "condition": "{}",
#                "action": json.dumps(p["action"]),
#                "weight": p["weight"],
#                "approval_status": p["approval_status"]
#            })

#        db.commit()

#    finally:
#        db.close()

def run_learning_cycle():

    logger = logging.getLogger(__name__)

    db = SessionLocal()

    try:
        # STEP 1: Extract patterns
        patterns = extract_patterns()
        print(f"Patterns: {len(patterns)}")
        print("PATTERNS DATA:", patterns)

        if not patterns:
            logger.info("No patterns found")
            return

        # STEP 2: Generate policies
        generated = generate_policies_from_patterns(patterns)
        print(f"Generated: {len(generated)}")
        print("GENERATED DATA:", generated)

        if not generated:
            logger.info("No policies generated")
            return

        # STEP 3: Validate
        valid = validate_policies(generated)
        print(f"Valid: {len(valid)}")

        if not valid:
            logger.info("No valid policies")
            return

        created_count = 0


        # STEP 4: Insert safely (NO DUPLICATION)
        for p in valid:

            if not isinstance(p.get("action"), dict):
                continue

            existing = db.execute(text("""
                SELECT COUNT(*) FROM policies
                WHERE agent_type = :agent_type
                 AND action = CAST(:action AS JSONB)
            """), {
                "agent_type": p.get("agent_type"),
                "action": json.dumps(p.get("action"))
            }).scalar()


            if existing > 0:
                continue

            db.execute(text("""
                INSERT INTO policies (agent_type, condition, action, weight, approval_status)
                VALUES (:agent_type, :condition, :action, :weight, 'approved')
            """), {
                "agent_type": p.get("agent_type"),
                "condition": str(p.get("condition", {})),
                "action": json.dumps(p.get("action")),
                "weight": p.get("weight", 1)
            })

            created_count += 1

        db.commit()

        logger.info(f"Learning cycle completed → created={created_count}")

    except Exception as e:
        logger.error(f"Learning cycle failed: {str(e)}")
        db.rollback()

    finally:
        db.close()

def prune_policies():
    db = SessionLocal()

    try:
        db.execute(text("""
            DELETE FROM policies
            WHERE id IN (
                SELECT id FROM policies
                ORDER BY weight ASC
                LIMIT 10
            )
        """))

        db.commit()

    finally:
        db.close()
