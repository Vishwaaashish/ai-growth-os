from sqlalchemy import text
from app.db.session import SessionLocal
import uuid


def log_usage(tenant_id: str, endpoint: str):
    db = SessionLocal()

    usage_id = f"use_{uuid.uuid4().hex[:8]}"

    db.execute(
        text("""
            INSERT INTO usage_logs (id, tenant_id, endpoint)
            VALUES (:id, :tenant_id, :endpoint)
        """),
        {
            "id": usage_id,
            "tenant_id": tenant_id,
            "endpoint": endpoint
        }
    )

    db.commit()
    db.close()
