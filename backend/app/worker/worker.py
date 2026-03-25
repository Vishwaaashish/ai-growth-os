import redis
from rq import Worker, Queue, Connection

# Import your execution logic
from app.workers.executor import execute_job

# Redis connection
redis_conn = redis.Redis(host="localhost", port=6379)

# Queue name (must match your enqueue logic)
queue = Queue("default", connection=redis_conn)


def job_handler(job, *args, **kwargs):
    """
    This function will be called for each job
    """
    return execute_job(job)


if __name__ == "__main__":
    with Connection(redis_conn):
        worker = Worker([queue])
        worker.work()
