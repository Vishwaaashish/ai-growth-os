from sqlalchemy import text
from app.db.session import SessionLocal
import uuid


def insert_policies(policies):
    db = SessionLocal()

    created = 0

    try:
        for p in policies:
            db.execute(text("""
                INSERT INTO policies (
                    id,
                    agent_type,
                    agent_name,
                    condition,
                    action,
                    weight,
                    confidence
                )
                VALUES (
                    :id,
                    :agent_type,
                    :agent_name,
                    :condition,
                    :action,
                    :weight,
                    :confidence
                )
            """), {
                "id": str(uuid.uuid4()),
                "agent_type": p.get("agent_type"),
                "agent_name": p.get("agent_name"),
                "condition": p.get("condition", {}),
                "action": p.get("action", {}),
                "weight": p.get("weight", 1.0),
                "confidence": 0.5
            })

            created += 1

        db.commit()
        return created

    except Exception as e:
        db.rollback()
        raise e

    finally:
        db.close()
