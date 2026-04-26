from fastapi import APIRouter, HTTPException, Header
from sqlalchemy import text
from app.db.session import SessionLocal
import uuid

from app.core.payments.razorpay_service import create_order
from app.core.audit.logger import log_action
from app.core.usage.logger import log_usage
from app.core.security.jwt_guard import decode_token


billing_router = APIRouter(prefix="/billing")


# =========================================================
# CREATE INVOICE (WITH LOGGING + QUOTA)
# =========================================================
@billing_router.post("/invoice")
def create_invoice(
    tenant_id: str,
    plan_id: str,
    amount: int,
    authorization: str = Header(...)
):
    db = SessionLocal()
    invoice_id = f"inv_{uuid.uuid4().hex[:8]}"

    try:
        # 🔹 Extract user from token
        token = authorization.split(" ")[1]
        payload = decode_token(token)
        user_id = payload.get("user_id")

        # 🔹 LOG USAGE
        log_usage(tenant_id, "/billing/invoice")

        # 🔹 LOG ACTION
        log_action(tenant_id, user_id, "create_invoice")

        # 🔹 QUOTA CHECK
        quota_check = db.execute(
            text("""
                SELECT used, quota 
                FROM api_keys 
                WHERE tenant_id = :tenant_id 
                LIMIT 1
            """),
            {"tenant_id": tenant_id}
        ).fetchone()

        if quota_check:
            used, quota = quota_check

            if used >= quota:
                db.close()
                raise HTTPException(status_code=403, detail="Quota exceeded")

            db.execute(
                text("""
                    UPDATE api_keys 
                    SET used = used + 1 
                    WHERE tenant_id = :tenant_id
                """),
                {"tenant_id": tenant_id}
            )

        # 🔹 CREATE INVOICE
        db.execute(
            text("""
                INSERT INTO invoices (id, tenant_id, plan_id, amount)
                VALUES (:id, :tenant_id, :plan_id, :amount)
            """),
            {
                "id": invoice_id,
                "tenant_id": tenant_id,
                "plan_id": plan_id,
                "amount": amount
            }
        )

        db.commit()

        return {"invoice_id": invoice_id}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=str(e))

    finally:
        db.close()


# =========================================================
# CREATE PAYMENT ORDER
# =========================================================
@billing_router.post("/create-order")
def create_payment_order(invoice_id: str):
    db = SessionLocal()

    invoice = db.execute(
        text("SELECT amount FROM invoices WHERE id = :id"),
        {"id": invoice_id}
    ).fetchone()

    if not invoice:
        db.close()
        raise HTTPException(status_code=404, detail="Invoice not found")

    amount = invoice[0]

    order = create_order(amount)

    db.close()

    return {
        "order_id": order["id"],
        "amount": amount
    }


# =========================================================
# CONFIRM PAYMENT
# =========================================================
@billing_router.post("/confirm-payment")
def confirm_payment(invoice_id: str):
    db = SessionLocal()

    db.execute(
        text("UPDATE invoices SET status='paid' WHERE id=:id"),
        {"id": invoice_id}
    )

    db.commit()
    db.close()

    return {"status": "payment_confirmed"}


# =========================================================
# LIST INVOICES
# =========================================================
@billing_router.get("/invoices")
def list_invoices():
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
