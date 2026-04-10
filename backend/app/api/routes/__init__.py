from fastapi import APIRouter

from app.api.routes.job import router as job_router
from app.api.routes.user import router as user_router
from app.api.routes.tenant import router as tenant_router

router = APIRouter()

# ---------------------------
# INCLUDE ALL ROUTES
# ---------------------------

router.include_router(job_router, prefix="/jobs", tags=["Jobs"])
router.include_router(user_router, prefix="/users", tags=["Users"])
router.include_router(tenant_router, prefix="/tenants", tags=["Tenants"])
