from fastapi import APIRouter, Depends
from app.core.security.jwt_guard import verify_jwt

secure_router = APIRouter()


@secure_router.get("/secure-test")
def secure_test(user=Depends(verify_jwt)):
    return {
        "status": "ok",
        "user_id": user["user_id"],
        "tenant_id": user["tenant_id"]
    }
