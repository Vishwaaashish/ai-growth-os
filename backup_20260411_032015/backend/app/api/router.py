from fastapi import APIRouter
from app.api.routes import user, tenant

router = APIRouter()

router.include_router(user.router, prefix="/users", tags=["Users"])
router.include_router(tenant.router, prefix="/tenants", tags=["Tenants"])
