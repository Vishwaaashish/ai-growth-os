from prometheus_client import Counter, Histogram, Gauge

# ---------------------------
# JOB METRICS
# ---------------------------

job_success_total = Counter("job_success_total", "Total successful jobs")

job_failure_total = Counter("job_failure_total", "Total failed jobs")

job_retry_total = Counter("job_retry_total", "Total retried jobs")

# ---------------------------
# QUEUE METRICS
# ---------------------------

queue_size = Gauge("queue_size", "Queue size by priority", ["queue_name"])

# ---------------------------
# WORKER METRICS
# ---------------------------

worker_execution_time = Histogram(
    "worker_execution_time_seconds", "Worker execution time in seconds"
)
