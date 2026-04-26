from app.core.config.config import settings
from sqlalchemy import text
from fastapi import APIRouter
from app.db.session import SessionLocal
import redis


health_router = APIRouter()

# Redis connection
redis_client = redis.Redis(
    host=settings.REDIS_HOST,
    port=settings.REDIS_PORT,
    decode_responses=True
)


@health_router.get("/health")
def health_check():
    status = {
        "api": "ok",
        "db": "unknown",
        "redis": "unknown"
    }

    # DB check
    try:
        db = SessionLocal()
        db.execute(text("SELECT 1"))
        status["db"] = "ok"
        db.close()
    except Exception as e:
        status["db"] = f"error: {str(e)}"

    # Redis check
    try:
        redis_client.ping()
        status["redis"] = "ok"
    except Exception as e:
        status["redis"] = f"error: {str(e)}"

    return status
