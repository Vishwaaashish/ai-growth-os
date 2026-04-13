import time
import threading

from rq import Queue
from app.queue.redis import redis_conn
from app.core.metrics import queue_size

# ---------------------------
# QUEUES
# ---------------------------

queues = {
    "high": Queue("high", connection=redis_conn),
    "default": Queue("default", connection=redis_conn),
    "low": Queue("low", connection=redis_conn),
    "dead": Queue("dead", connection=redis_conn),
}

# ---------------------------
# LOOP
# ---------------------------


def update_queue_metrics():
    print("🚀 Queue metrics thread started...")  # DEBUG

    while True:
        try:
            for name, q in queues.items():
                size = len(q)
                print(f"[Queue] {name}: {size}")  # DEBUG
                queue_size.labels(queue_name=name).set(size)

        except Exception as e:
            print(f"[QueueMetricsError] {e}")

        time.sleep(5)


# ---------------------------
# START THREAD
# ---------------------------


def start_queue_metrics():
    thread = threading.Thread(target=update_queue_metrics, daemon=True)
    thread.start()
