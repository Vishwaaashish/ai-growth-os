from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel

from app.db.session import SessionLocal
from app.models.job import Job
from app.workers.tasks import execute_job

from redis import Redis
from rq import Queue

# Router
router = APIRouter()

# Redis connection
redis_conn = Redis(host="localhost", port=6379)
queue = Queue(connection=redis_conn)

# ---------------------------
# DB Dependency
# ---------------------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ---------------------------
# Request Schema
# ---------------------------
class JobRequest(BaseModel):
    type: str
    payload: dict

# ---------------------------
# CREATE JOB (STEP 5)
# ---------------------------
@router.post("/execute")
def create_job(request: JobRequest, db: Session = Depends(get_db)):
    job = Job(
        type=request.type,
        payload=request.payload,
        status="pending"
    )

    db.add(job)
    db.commit()
    db.refresh(job)

    # Push to queue (Worker will pick)
    queue.enqueue(execute_job, str(job.id))

    return {
        "job_id": str(job.id),
        "status": "queued"
    }

# ---------------------------
# GET JOB STATUS (STEP 7)
# ---------------------------
@router.get("/jobs/{job_id}")
def get_job(job_id: str, db: Session = Depends(get_db)):
    job = db.query(Job).filter(Job.id == job_id).first()

    if not job:
        return {"error": "Job not found"}

    return {
        "id": str(job.id),
        "status": job.status,
        "result": job.result
    }
