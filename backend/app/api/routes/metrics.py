from fastapi import APIRouter
from app.core.observability.metrics import get_metrics

router = APIRouter()

@router.get("/metrics")
def metrics():
    return get_metrics()
