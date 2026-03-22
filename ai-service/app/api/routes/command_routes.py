from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
import redis
from rq import Queue

from app.schemas.command import CommandCreate
from app.services.command_service import create_command
from app.database.connection import SessionLocal
from app.services.tasks import process_command

router = APIRouter()

# -------------------------------
# DB Dependency
# -------------------------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# -------------------------------
# Redis + Queue Setup
# -------------------------------
redis_conn = redis.Redis(host='localhost', port=6379, decode_responses=True)
q = Queue(connection=redis_conn)

# -------------------------------
# Execute Endpoint
# -------------------------------
@router.post("/execute")
def execute_command(payload: CommandCreate, db: Session = Depends(get_db)):

    # 1️⃣ Check Cache First
    cached = redis_conn.get(payload.input_text)
    if cached:
        return {
            "source": "cache",
            "response": cached
        }

    # 2️⃣ Store in DB
    command = create_command(db, payload.user_id, payload.input_text)

    # 3️⃣ Send to Background Worker
    job = q.enqueue(process_command, command.id)

    return {
        "status": "queued",
        "job_id": job.id,
        "command_id": command.id
    }
