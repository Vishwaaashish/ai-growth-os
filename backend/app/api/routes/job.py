from app.worker.executor import execute_job
from app.core.learning.policies.policy_engine import select_policy
from app.core.learning.policies.policy_executor import apply_policy
from app.queue.redis import high_queue, default_queue, low_queue

from pydantic import BaseModel
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.models.job import Job

import json

router = APIRouter()


# 🔷 REQUEST SCHEMA
class JobRequest(BaseModel):
    type: str
    payload: dict


# 🔷 DB DEPENDENCY
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# 🔷 CREATE JOB (FIXED + CLEAN)
@router.post("/job")
def create_job(request: JobRequest):
    db = SessionLocal()

    try:
        # STEP 1: select policy
        policy = select_policy(request.type, request.payload)

        # STEP 2: extract policy_id safely
        policy_id = policy.get("id") if policy else None

        # STEP 3: create job WITH policy_id
        job = Job(
            type=request.type,
            payload=json.dumps(request.payload),
            status="pending",
            policy_id=policy_id
        )

        # STEP 4: save job
        db.add(job)
        db.commit()
        db.refresh(job)

        # STEP 5: execution plan
        execution_plan = apply_policy(job, policy) if policy else {"queue": "default"}
        queue_type = execution_plan.get("queue", "default")

        if queue_type == "high":
            selected_queue = high_queue
        elif queue_type == "low":
            selected_queue = low_queue
        else:
            selected_queue = default_queue

        # STEP 6: enqueue
        selected_queue.enqueue("app.worker.executor.execute_job", job.id)

        return {
            "job_id": job.id,
            "policy": policy,
            "queue": queue_type
        }

    except Exception as e:
        return {"error": str(e)}

    finally:
        db.close()


# 🔷 GET JOB STATUS
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
        "policy_id": job.policy_id,  # ✅ added for visibility
    }
