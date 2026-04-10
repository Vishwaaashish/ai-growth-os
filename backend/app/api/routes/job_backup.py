from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.models.job import Job
from app.worker.tasks import execute_job
from app.queue.redis import redis_conn
from rq import Queue

router = APIRouter()

q = Queue(connection=redis_conn)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/execute")
def create_job(request: dict, db: Session = Depends(get_db)):
    job = Job(
        type=request.get("type"), payload=request.get("payload"), status="pending"
    )
    db.add(job)
    db.commit()
    db.refresh(job)

    q.enqueue(execute_job, str(job.id))

    return {"job_id": str(job.id)}
