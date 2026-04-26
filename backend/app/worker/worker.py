from app.core.logger import logger
from rq import Worker, Queue
from app.queue.redis import redis_conn
from app.core.metrics import job_retry_total

listen = ["high", "default", "low", "dead"]


class InstrumentedWorker(Worker):
    def handle_job_failure(self, job, *exc_info, **kwargs):
        if job.retries_left:
            job_retry_total.inc()
        return super().handle_job_failure(job, *exc_info, **kwargs)


if __name__ == "__main__":
    queues = [Queue(name, connection=redis_conn) for name in listen]

    worker = InstrumentedWorker(queues, connection=redis_conn)

    logger.info("worker_started", extra={"message": "Worker started with metrics enabled"})
    worker.work()
