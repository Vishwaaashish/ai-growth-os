from app.core.security.role_guard import require_admin
from fastapi import Depends

from sqlalchemy import text
from fastapi import APIRouter, HTTPException
from app.db.session import SessionLocal
import uuid

tenant_admin_router = APIRouter(prefix="/admin")


# 🔷 CREATE TENANT
@tenant_admin_router.post("/tenant")
def create_tenant(name: str):
    db = SessionLocal()

    tenant_id = f"tenant_{uuid.uuid4().hex[:8]}"

    db.execute(
        text("INSERT INTO tenants (id, name) VALUES (:id, :name)"),
        {"id": tenant_id, "name": name}
    )

    db.commit()
    db.close()

    return {"tenant_id": tenant_id}


# 🔷 GENERATE API KEY
@tenant_admin_router.post("/api-key")
def generate_api_key(tenant_id: str):
    db = SessionLocal()

    try:
        key = uuid.uuid4().hex

        db.execute(
            text("""
                INSERT INTO api_keys (key, tenant_id, quota, used)
                VALUES (:key, :tenant_id, 1000, 0)
            """),
            {
                "key": key,
                "tenant_id": tenant_id
            }
        )

        db.commit()

        return {
            "api_key": key,
            "tenant_id": tenant_id
        }

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        db.close()


# 🔷 LIST API KEYS
@tenant_admin_router.get("/api-keys/{tenant_id}")
def list_keys(tenant_id: str):
    db = SessionLocal()

    rows = db.execute(
        text("SELECT key, quota, used FROM api_keys WHERE tenant_id = :tenant_id"),
        {"tenant_id": tenant_id}
    ).fetchall()

    db.close()

    return {"keys": [dict(r._mapping) for r in rows]}

@tenant_admin_router.post("/tenant", dependencies=[Depends(require_admin)])
def create_tenant(name: str):
    db = SessionLocal()

    tenant_id = f"tenant_{uuid.uuid4().hex[:8]}"

    db.execute(
        text("INSERT INTO tenants (id, name) VALUES (:id, :name)"),
        {"id": tenant_id, "name": name}
    )

    db.commit()
    db.close()

    return {"tenant_id": tenant_id}
