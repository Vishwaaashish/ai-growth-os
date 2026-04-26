from fastapi import Header, HTTPException, status
from sqlalchemy import text
from app.db.session import SessionLocal
from app.core.logger import logger

# 🔧 Toggle this for testing vs production
TEST_MODE = True


def verify_api_key(x_api_key: str = Header(None)):

    if not x_api_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="API key missing"
        )

    db = SessionLocal()

    try:
        result = db.execute(text("""
            SELECT 
                k.tenant_id,
                s.plan_id,
                p.request_limit,
                k.used
            FROM api_keys k
            JOIN subscriptions s ON k.tenant_id = s.tenant_id
            JOIN plans p ON s.plan_id = p.id
            WHERE k.key = :key
        """), {"key": x_api_key}).fetchone()

        if not result:
            raise HTTPException(status_code=403, detail="Invalid API key")

        tenant_id, plan_id, limit, used = result

        # =========================
        # 🔒 PLAN LIMIT CONTROL (FIXED)
        # =========================
        if used >= limit:

            if TEST_MODE:
                # ✅ BYPASS (NON-BLOCKING)
                logger.warning(
                    "plan_limit_exceeded_but_bypassed",
                    extra={
                        "api_key": x_api_key,
                        "tenant_id": str(tenant_id),
                        "used": used,
                        "limit": limit
                    }
                )

                # ⚠️ DO NOT increment usage beyond limit (optional control)
                return {"tenant_id": tenant_id}

            else:
                # 🔒 PRODUCTION MODE
                raise HTTPException(
                    status_code=403,
                    detail="Plan limit exceeded"
                )

        # =========================
        # ✅ NORMAL FLOW
        # =========================
        db.execute(
            text("UPDATE api_keys SET used = used + 1 WHERE key = :key"),
            {"key": x_api_key}
        )

        db.commit()

        return {"tenant_id": tenant_id}

    except Exception as e:
        db.rollback()
        raise e

    finally:
        db.close()
