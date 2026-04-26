from fastapi import APIRouter, HTTPException
from sqlalchemy import text
from app.db.session import SessionLocal
import uuid

subscription_router = APIRouter(prefix="/admin")


@subscription_router.post("/assign-plan")
def assign_plan(tenant_id: str, plan_id: str):
    db = SessionLocal()

    sub_id = f"sub_{uuid.uuid4().hex[:8]}"

    try:
        db.execute(
            text("""
                INSERT INTO subscriptions (id, tenant_id, plan_id)
                VALUES (:id, :tenant_id, :plan_id)
            """),
            {
                "id": sub_id,
                "tenant_id": tenant_id,
                "plan_id": plan_id
            }
        )
        db.commit()
        return {"subscription_id": sub_id}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=str(e))

    finally:
        db.close()
