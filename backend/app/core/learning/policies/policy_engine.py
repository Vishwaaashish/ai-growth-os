import logging
from sqlalchemy import text

from app.core.learning.policies.policy_store import get_policies
from app.core.learning.policies.conflict_resolver import resolve_conflicts
from app.core.learning.policies.scoring import compute_policy_score
from app.decision_engine import apply_priority_arbitration

from app.db.session import SessionLocal

logger = logging.getLogger(__name__)


# 🔷 POLICY SELECTION ENGINE (PHASE 6.4)
def select_policy(agent_type, state):
    # Step 1: fetch policies
    policies = get_policies(agent_type)

    # Step 2: match policies
    matched = []
    for p in policies:
        if match_condition(p["condition"], state):
            matched.append(p)

    if not matched:
        logger.info("No policies matched")
        return None

    # Step 3: conflict resolution
    candidates = resolve_conflicts(matched, state)

    if not candidates:
        logger.info("No candidates after conflict resolution")
        return None

    # Step 4: priority arbitration (override layer)
    priority_policy = apply_priority_arbitration(candidates)
    if priority_policy:
        logger.info({
            "type": "priority_override",
            "selected_policy": priority_policy.get("id"),
            "priority": priority_policy.get("priority")
        })
        return priority_policy

    # Step 5: scoring system (weighted decision)
    scored = []
    for p in candidates:
        score = compute_policy_score(p, p.get("metrics"))

        # backward compatibility
        weight = p.get("weight", 1)

        if p.get("metrics"):
            success = p["metrics"]["success_count"]
            failure = p["metrics"]["failure_count"]

            if success > failure:
                p["weight"] = min(p.get("weight", 1) + 0.2, 5)
            else:
                p["weight"] = max(p.get("weight", 1) - 0.2, 0.1)

        # final hybrid score
        final_score = (0.7 * score) + (0.3 * weight)

        p["score"] = round(score, 4)
        p["final_score"] = round(final_score, 4)

        scored.append(p)

    # Step 6: select best policy
    ranked = sorted(
        scored,
        key=lambda x: x["final_score"],
        reverse=True
    )

    best_policy = ranked[0]

    # 🔷 LOGGING (MANDATORY)
    logger.info({
        "type": "policy_selection",
        "matched_count": len(matched),
        "candidate_count": len(candidates),
        "selected_policy": best_policy.get("id"),
        "scores": [
            {
                "id": p.get("id"),
                "score": p.get("score"),
                "final_score": p.get("final_score")
            } for p in ranked
        ]
    })

    return best_policy


# 🔷 CONDITION MATCHING ENGINE (UNCHANGED — SAFE)
def match_condition(condition, state):
    for key, value in condition.items():
        state_value = str(state.get(key, ""))

        # Pattern matching (contains)
        if isinstance(value, str):
            if value not in state_value:
                return False

        # Exact match fallback
        else:
            if state.get(key) != value:
                return False

    return True


# 🔷 POLICY GENERATION (UNCHANGED — EXTENDED SAFE)
def generate_policies():
    db = SessionLocal()

    try:
        insights = db.execute(text("""
            SELECT agent_id, pattern_type, confidence_score
            FROM learning_insights
        """)).fetchall()

        for row in insights:
            agent_id, pattern, confidence = row

            if pattern == "success_pattern" and confidence >= 1:
                db.execute(text("""
                    INSERT INTO policies (
                        agent_type,
                        condition,
                        action,
                        weight,
                        approval_status
                    )
                    VALUES (
                        :agent,
                        :condition,
                        :action,
                        :weight,
                        'approved'
                    )
                """), {
                    "agent": agent_id,
                    "condition": {"pattern": "success_pattern"},
                    "action": {"priority": "high"},
                    "weight": confidence
                })

        db.commit()
        logger.info("Policies generated successfully")

    except Exception as e:
        logger.error(f"Policy Engine Error: {str(e)}")
        db.rollback()

    finally:
        db.close()
