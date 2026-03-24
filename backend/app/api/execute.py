from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.models.job import Job
from redis import Redis
from rq import Queue

router = APIRouter()

# Redis connection
redis_conn = Redis(host="localhost", port=6379)
queue = Queue(connection=redis_conn)


# Dependency for DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/execute")
def execute_job(job_type: str, payload: dict, db: Session = Depends(get_db)):
    # Create DB job
    job = Job(type=job_type, payload=payload, status="pending")
    db.add(job)
    db.commit()
    db.refresh(job)

    # Push to Redis queue
    queue.enqueue("app.worker.tasks.process_job", str(job.id))

    return {
        "job_id": str(job.id),
        "status": "queued"
    }
