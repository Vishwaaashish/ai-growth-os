import json
import time
import random

from app.db.session import SessionLocal
from app.models.job import Job

from app.core.observability.metrics import increment, record_timing
from app.core.observability.trace import start_trace, end_trace
from app.core.observability.logger import get_logger
from app.core.observability.failures import log_failure

from app.core.learning.learning_orchestrator import run_learning_cycle
from app.core.learning.policies.policy_engine import select_policy
from app.core.learning.feedback import update_policy_metrics
from app.core.learning.agents.agent_metrics import update_agent_score
from app.core.intelligence.memory.learning_memory import store_learning_event

from app.core.security.execution_guard import validate_job_execution
from app.core.security.circuit_breaker import is_circuit_open, record_failure

logger = get_logger(__name__)


def execute_job(job_id: int):
    db = SessionLocal()
    trace = start_trace()
    error_msg = None

    increment("jobs_total")
    print("DEBUG: jobs_total incremented")

    try:
        # =========================
        # STEP 1: FETCH JOB
        # =========================
        job = db.query(Job).filter(Job.id == job_id).first()

        if not job:
            logger.error({"type": "job_missing", "job_id": job_id})
            return {"error": "Job not found"}

        validate_job_execution(job)

        payload = json.loads(job.payload or "{}")

        # =========================
        # STEP 2: CIRCUIT BREAKER
        # =========================
        if is_circuit_open(job.type):
            logger.warning({
                "type": "circuit_open",
                "job_type": job.type,
                "job_id": job_id
            })
            return {"status": "circuit_open", "job_id": job_id}

        # =========================
        # STEP 3: POLICY SELECTION
        # =========================
        policy, ranked = select_policy(job.type, payload)

        if not policy or not isinstance(policy, dict):
            raise Exception(f"Invalid policy: {policy}")

        policy_id = policy.get("id")
        if not isinstance(policy_id, int):
            policy_id = None

        agent_name = policy.get("agent_name", "fallback")

        job.status = "running"
        job.policy_id = policy_id
        db.commit()

        start_time = time.time()

        logger.info({
            "type": "job_start",
            "job_id": job_id,
            "policy_id": policy_id
        })

        # =========================
        # STEP 4: EXECUTION ROUTING
        # =========================
        if job.type in ["test", "test_job"]:
            result = {
                "status": "success",
                "message": f"Executed job type: {job.type}"
            }

        else:
            raise Exception(f"Unknown job type: {job.type}")

        latency = int((time.time() - start_time) * 1000)

        # =========================
        # STEP 5: SUCCESS HANDLING
        # =========================
        job.status = "completed"
        job.result = json.dumps(result)
        db.commit()

        # Metrics
        increment("jobs_success")
        record_timing("job_execution_time", latency / 1000.0)

        # Policy metrics
        if policy_id:
            update_policy_metrics(policy_id=policy_id, success=True, latency=latency)
            store_learning_event(policy_id, True, latency)

        # Agent score
        try:
            update_agent_score(agent_name, True)
        except Exception as e:
            logger.error({"type": "agent_score_error", "error": str(e)})

        # Learning trigger
        if random.random() < 0.3:
            run_learning_cycle()

        # =========================
        # STEP 6: TRACE LOGGING
        # =========================
        trace = end_trace(trace)

        logger.info({
            "type": "job_execution",
            "trace_id": trace.get("trace_id"),
            "job_id": job_id,
            "duration": trace.get("duration"),
            "status": "completed"
        })

        return {
            "job_id": job_id,
            "policy": policy,
            "latency_ms": latency
        }

    except Exception as e:
        error_msg = str(e) if e else "Unknown error"

        increment("jobs_failure")
        record_timing("job_execution_time", (time.time() - start_time))
        record_failure(job.type)

        logger.error({
            "type": "executor_error",
            "job_id": job_id,
            "error": error_msg
        })

        log_failure({
            "job_id": job_id,
            "error": error_msg
        })

        retry_count = getattr(job, "retry_count", 0)

        if retry_count < 2:
            logger.warning({
                "type": "job_retry",
                "job_id": job_id,
                "retry": retry_count + 1
            })

            job.retry_count = retry_count + 1
            job.status = "queued"
            db.commit()

            return {"status": "retrying"}

        # FINAL FAILURE
        db.rollback()

        job = db.query(Job).filter(Job.id == job_id).first()

        if job:
            job.status = "failed"
            job.error = error_msg

            if getattr(job, "retry_count", 0) >= 2:
                job.status = "dead"

            db.commit()

        # Policy failure metrics
        if policy_id:
            update_policy_metrics(policy_id=policy_id, success=False, latency=0)
            store_learning_event(policy_id, False, 0)

        # Agent failure score
        try:
            update_agent_score(agent_name, False)
        except Exception as e:
            logger.error({"type": "agent_score_error", "error": str(e)})

        # Learning trigger
        if random.random() < 0.3:
            run_learning_cycle()

        trace = end_trace(trace)

        logger.info({
            "type": "job_execution",
            "trace_id": trace.get("trace_id"),
            "job_id": job_id,
            "duration": trace.get("duration"),
            "status": "failed"
        })

        return {"error": error_msg}

    finally:
        db.close()
