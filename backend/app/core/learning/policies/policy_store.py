from sqlalchemy import text
from app.db.session import SessionLocal
import json
import logging
logger = logging.getLogger(__name__)


# -------------------------------
# SAFE JSON HANDLER
# -------------------------------
def safe_json(value):
    if value is None:
        return {}
    if isinstance(value, dict):
        return value
    try:
        return json.loads(value)
    except Exception:
        return {}


# -------------------------------
# GET POLICIES (PHASE 6.4 FINAL)
# -------------------------------
def get_policies(agent_type):
    db = SessionLocal()

    try:
        result = db.execute(text("""
            SELECT id, condition, recommended_action, action, weight, approval_status
            FROM policies
            WHERE agent_type = :agent
            AND approval_status = 'approved'
        """), {"agent": agent_type}).fetchall()

        policies = []

        # -------------------------------
        # BUILD POLICY OBJECTS
        # -------------------------------
        for row in result:
            row_dict = dict(row._mapping)

            condition = safe_json(row_dict.get("condition"))

            # PRIORITY: action > recommended_action
            if row_dict.get("action"):
                action_data = row_dict.get("action")
            else:
                action_data = row_dict.get("recommended_action")

            action = safe_json(action_data)

            policy = {
                "id": row_dict.get("id"),
                "agent_type": agent_type,
                "condition": condition,
                "action": action,
                "weight": row_dict.get("weight", 1),

                # scoring fields
                "priority": action.get("priority", 0),
                "confidence": row_dict.get("confidence", 0.5),
                "success_rate": row_dict.get("success_rate", 0.5),
                "created_at": row_dict.get("created_at", 0),
            }

            policies.append(policy)

        # -------------------------------
        # LOAD METRICS (SAFE)
        # -------------------------------
        metrics_rows = db.execute(
            text("SELECT * FROM policy_metrics")
        ).fetchall()

        metrics_map = {
            row.policy_id: row for row in metrics_rows
        }

        # -------------------------------
        # ATTACH METRICS
        # -------------------------------
        for p in policies:
            m = metrics_map.get(p["id"])

            if m:
                p["metrics"] = {
                    "success_count": m.success_count,
                    "failure_count": m.failure_count,
                    "avg_latency": m.avg_latency,
                }
            else:
                p["metrics"] = None

        return policies

    except Exception as e:
        logger.error(f"[POLICY STORE ERROR] {str(e)}", exc_info=True)
        return []

    finally:
        db.close()
