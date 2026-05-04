from fastapi import APIRouter
from sqlalchemy import text
from app.db.session import SessionLocal

router = APIRouter()

# =========================
# 🔹 CREATIVE DASHBOARD (PRIMARY UI API)
# =========================
@router.get("/dashboard")
def get_dashboard():
    db = SessionLocal()

    try:
        rows = db.execute(text("""
            SELECT DISTINCT ON (cm.creative_id)
                cm.creative_id,
                cm.ctr,
                cm.cpa,
                cm.roas,
                cm.frequency,
                al.decision,
                al.action,
                al.confidence,
                al.timestamp
            FROM creative_metrics cm

            LEFT JOIN action_logs al
            ON al.creative_id = cm.creative_id
            AND al.timestamp = (
                SELECT MAX(timestamp)
                FROM action_logs
                WHERE creative_id = cm.creative_id
            )

            ORDER BY cm.creative_id, cm.updated_at DESC
        """)).fetchall()

        return [
            {
                "creative_id": r.creative_id,
                "ctr": float(r.ctr or 0),
                "cpa": float(r.cpa or 0),
                "roas": float(r.roas or 0),
                "frequency": float(r.frequency or 0),

                # ✅ STRICT MAPPING (NO UNKNOWN)
                "decision": r.decision or "insufficient_data",
                "action": r.action or "test",

                "confidence": float(r.confidence or 0),
                "timestamp": str(r.timestamp) if r.timestamp else None
            }
            for r in rows
        ]

    except Exception as e:
        return {"error": str(e)}

    finally:
        db.close()


# =========================
# 🔹 ACTION STREAM (REAL-TIME FEED)
# =========================
@router.get("/dashboard/actions")
def get_recent_actions():
    db = SessionLocal()

    try:
        rows = db.execute(text("""
            SELECT creative_id, action, decision, confidence, timestamp
            FROM action_logs
            ORDER BY timestamp DESC
            LIMIT 100
        """)).fetchall()

        return [
            {
                "creative_id": r.creative_id,
                "action": r.action or "test",
                "decision": r.decision or "insufficient_data",
                "confidence": float(r.confidence or 0),
                "timestamp": str(r.timestamp)
            }
            for r in rows
        ]

    except Exception as e:
        return {"error": str(e)}

    finally:
        db.close()


# =========================
# 🔹 POLICY METRICS (AI INTELLIGENCE VIEW)
# =========================
@router.get("/dashboard/policies")
def get_policy_metrics():
    db = SessionLocal()

    try:
        rows = db.execute(text("""
            SELECT id, confidence, success_count, failure_count, usage_count
            FROM policies
            ORDER BY confidence DESC
        """)).fetchall()

        return [
            {
                "policy_id": r.id,
                "confidence": float(r.confidence or 0),
                "success": int(r.success_count or 0),
                "failure": int(r.failure_count or 0),
                "usage": int(r.usage_count or 0)
            }
            for r in rows
        ]

    except Exception as e:
        return {"error": str(e)}

    finally:
        db.close()



