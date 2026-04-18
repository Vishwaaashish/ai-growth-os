import time

from app.worker.executor import execute_job
from app.core.metrics import job_success_total, job_failure_total, worker_execution_time
import logging
logger = logging.getLogger(__name__)


# ---------------------------
# INSTRUMENTATION WRAPPER
# ---------------------------


def instrumented_task(func):
    def wrapper(*args, **kwargs):
        start = time.time()

        try:
            result = func(*args, **kwargs)
            job_success_total.inc()
            return result

        except Exception as e:
            job_failure_total.inc()
            logger.error(f"[TASK ERROR] {str(e)}", exc_info=True)
            raise

        finally:
            duration = time.time() - start
            worker_execution_time.observe(duration)

    return wrapper


# ---------------------------
# ACTUAL TASK (INSTRUMENTED)
# ---------------------------


@instrumented_task
def run_job(job_id: str):
    return execute_job(job_id)
