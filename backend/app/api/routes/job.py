from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.models.job import Job

from app.queue.redis import high_queue, default_queue, low_queue

import json

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# 🔴 PRIORITY ROUTER
def get_queue(priority: str):
    if priority == "high":
        return high_queue
    elif priority == "low":
        return low_queue
    return default_queue


@router.post("/jobs")
def create_job(
    payload: dict,
    job_type: str,
    priority: str = "default",
    db: Session = Depends(get_db),
):
    job = Job(
        type=job_type, payload=json.dumps(payload), status="queued", priority=priority
    )

    db.add(job)
    db.commit()
    db.refresh(job)

    queue = get_queue(priority)

    queue.enqueue("app.worker.tasks.run_job", job.id)

    return {"job_id": job.id, "status": "queued", "priority": priority}


@router.get("/jobs/{job_id}")
def get_job_status(job_id: int, db: Session = Depends(get_db)):
    job = db.query(Job).filter(Job.id == job_id).first()

    if not job:
        return {"error": "Job not found"}

    return {
        "id": job.id,
        "type": job.type,
        "status": job.status,
        "retries": job.retries,
        "result": job.result,
        "error": job.error,
    }
