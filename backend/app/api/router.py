from fastapi import APIRouter
from app.api.routes import job

router = APIRouter()

router.include_router(job.router, prefix="/jobs", tags=["Jobs"])
