from sqlalchemy import text
from app.db.session import SessionLocal
from fastapi import APIRouter, Depends

from app.core.security.admin_guard import verify_admin

system_admin_router = APIRouter(prefix="/admin")


# =========================================
# SYSTEM STATUS
# =========================================
@system_admin_router.get("/system-status", dependencies=[Depends(verify_admin)])
def system_status():
    return {"status": "ok"}


# =========================================
# USAGE LOGS
# =========================================
@system_admin_router.get("/usage", dependencies=[Depends(verify_admin)])
def get_usage(limit: int = 10, offset: int = 0):
    db = SessionLocal()

    rows = db.execute(
        text("""
            SELECT *
            FROM usage_logs
            ORDER BY created_at DESC
            LIMIT :limit OFFSET :offset
        """),
        {"limit": limit, "offset": offset}
    ).fetchall()

    db.close()
    return [dict(r._mapping) for r in rows]


#        rows = db.execute(text("SELECT * FROM usage_logs LIMIT 50")).fetchall()
#        return [dict(r._mapping) for r in rows]

# =========================================
# AUDIT LOGS
# =========================================
@system_admin_router.get("/audit", dependencies=[Depends(verify_admin)])
def get_audit(limit: int = 10, offset: int = 0):
    db = SessionLocal()

    rows = db.execute(
        text("""
            SELECT *
            FROM audit_logs
            ORDER BY created_at DESC
            LIMIT :limit OFFSET :offset
        """),
        {"limit": limit, "offset": offset}
    ).fetchall()

    db.close()
    return [dict(r._mapping) for r in rows]


 #       rows = db.execute(text("SELECT * FROM audit_logs LIMIT 50")).fetchall()
 #       return [dict(r._mapping) for r in rows]

# =========================================
# ADMIN: TENANTS
# =========================================
@system_admin_router.get("/tenants", dependencies=[Depends(verify_admin)])
def get_tenants():
    db = SessionLocal()

    rows = db.execute(
        text("SELECT id, name, created_at FROM tenants")
    ).fetchall()

    db.close()

    return [dict(r._mapping) for r in rows]


# =========================================
# ADMIN: INVOICES
# =========================================
@system_admin_router.get("/invoices", dependencies=[Depends(verify_admin)])
def get_all_invoices():
    db = SessionLocal()

    rows = db.execute(
        text("""
            SELECT id, tenant_id, amount, status, created_at
            FROM invoices
            ORDER BY created_at DESC
        """)
    ).fetchall()

    db.close()

    return [dict(r._mapping) for r in rows]
