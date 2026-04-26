from fastapi import APIRouter, HTTPException
from app.db.session import SessionLocal
from sqlalchemy import text
from app.core.security.auth import hash_password, verify_password, create_access_token
import uuid

auth_router = APIRouter(prefix="/auth")


@auth_router.post("/signup")
def signup(email: str, password: str, tenant_id: str):
    db = SessionLocal()

    hashed = hash_password(password)

    user_id = f"user_{uuid.uuid4().hex[:8]}"

    try:
        db.execute(
            text("""
                INSERT INTO users (id, email, password, tenant_id)
                VALUES (:id, :email, :password, :tenant_id)
            """),
            {
                "id": user_id,
                "email": email,
                "password": hashed,
                "tenant_id": tenant_id
            }
        )
        db.commit()
        return {"user_id": user_id}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=str(e))

    finally:
        db.close()


@auth_router.post("/login")
def login(email: str, password: str):
    db = SessionLocal()

    user = db.execute(
        text("SELECT id, password, role, tenant_id FROM users WHERE email = :email"),
        {"email": email}
    ).fetchone()

    db.close()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user_id, hashed, role, tenant_id = user

    if not verify_password(password, hashed):
        raise HTTPException(status_code=403, detail="Invalid credentials")

    token = create_access_token({
        "user_id": user_id,
        "role": role,
        "tenant_id": tenant_id
    })

    return {"access_token": token}
