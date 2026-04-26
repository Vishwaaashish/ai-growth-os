from sqlalchemy import text
from app.db.session import SessionLocal
import uuid


def log_action(tenant_id: str, user_id: str, action: str):
    db = SessionLocal()

    log_id = f"log_{uuid.uuid4().hex[:8]}"

    db.execute(
        text("""
            INSERT INTO audit_logs (id, tenant_id, user_id, action)
            VALUES (:id, :tenant_id, :user_id, :action)
        """),
        {
            "id": log_id,
            "tenant_id": tenant_id,
            "user_id": user_id,
            "action": action
        }
    )

    db.commit()
    db.close()
