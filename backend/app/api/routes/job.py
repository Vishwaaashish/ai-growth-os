

from app.core.observability.metrics import increment
from app.worker.executor import execute_job

from app.core.learning.policies.policy_engine import select_policy
from app.core.learning.policies.policy_executor import apply_policy

from app.queue.redis import high_queue, default_queue, low_queue


from app.core.security.api_key_guard import verify_api_key
from app.core.security.input_guard import validate_job_input
from app.core.security.rate_limiter import allow_request
from app.core.security.security_logger import log_security_event

from fastapi import Request
from fastapi import HTTPException
from pydantic import BaseModel
from fastapi import APIRouter, Depends

from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.models.job import Job
from app.core.logger import logger
import json

from uuid import uuid4

from rq import Queue
from redis import Redis

# ✅ Redis connection (must match docker service name)
redis_conn = Redis(host="redis", port=6379, decode_responses=True)

# ✅ Queue
q = Queue("default", connection=redis_conn)

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


@router.post("/job")
async def create_job(request: Request, auth=Depends(verify_api_key)):
    tenant_id = auth["tenant_id"]

    db = SessionLocal()

    body = await request.json()

    valid, error = validate_job_input(body)

    if not valid:
        log_security_event("invalid_input", body)

        raise HTTPException(
            status_code=400,
            detail={
                "type": "validation_error",
                "message": error
            }
        )

    # Safe parsing AFTER guard
    request_data = JobRequest(**body)

    increment("jobs_total", tenant_id)

    try:
        client_id = "local"  # later replace with real user

       # if not allow_request(client_id):
        #    logger.warning("rate_limited_skip", extra={"client_id": client_id})
         #   return {"status": "failed", "error": "rate_limited_skip"}

       # STEP 1: select policy
        policy_result = select_policy(request_data.type, request_data.payload)

        # unpack properly
        if not isinstance(policy_result, tuple):
            raise Exception(f"select_policy must return tuple, got {type(policy_result)}")

        policy, ranked = policy_result

        if policy is None:   #change later both lines
            logger.warning(
                "no_policy_selected",
                extra={"action": "proceed_without_override"}
            )

        # STEP 2: extract policy_id safely

        policy_id = policy.get("id") if policy else None

        if not isinstance(policy_id, int):
            policy_id = None


        # STEP 3: create job WITH policy_id
        job = Job(
            type=request_data.type,
            payload=json.dumps(request_data.payload),
            status="pending",
            policy_id=policy_id,
            tenant_id=tenant_id
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
        error_msg = str(e) if e else "Unknown error"
        logger.error(
            "job_api_error",
            extra={"error": error_msg},
            exc_info=True
        )
        return {"status": "failed", "error": error_msg}

    finally:
        db.close()


# 🔷 GET JOB STATUS

@router.get("/jobs/{job_id}")
def get_job_status(
    job_id: int,
    request: Request,
    auth=Depends(verify_api_key),
    db: Session = Depends(get_db)
):
    tenant_id = auth["tenant_id"]

    job = db.query(Job).filter(
        Job.id == job_id,
        Job.tenant_id == tenant_id
    ).first()

    if not job:
        logger.warning(
            "tenant_access_violation",
             extra={
                 "job_id": job_id,
                 "tenant_id": tenant_id
             }
        )

    return {
        "id": job.id,
        "type": job.type,
        "status": job.status,
        "retries": job.retries,
        "result": job.result,
        "error": job.error,
        "policy_id": job.policy_id,  # ✅ added for visibility
    }

@router.post("/run-job")
def run_job():
    db = SessionLocal()

    try:
        # ✅ CREATE JOB RECORD
        job = Job(
            id=uuid4(),
            type="ai",
            payload=json.dumps({}),
            status="queued",
            tenant_id="local"
        )

        db.add(job)
        db.commit()
        db.refresh(job)

        # ✅ PUSH TO REDIS QUEUE (CRITICAL FIX)
        q.enqueue("app.worker.executor.execute_job", str(job.id))

        print("JOB ENQUEUED:", job.id)

        return {
            "status": "job_triggered",
            "job_id": str(job.id)
        }

    finally:
        db.close()

