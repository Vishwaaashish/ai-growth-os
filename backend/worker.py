import time
import random
import redis
import os

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
r = redis.Redis(host=REDIS_HOST, port=6379, decode_responses=True)

print("[WORKER] STARTED")

while True:
    job = r.lpop("job_queue")

    if job:
        print(f"[WORKER] Processing {job}")
        time.sleep(random.uniform(0.5, 2.0))
        print(f"[WORKER] Done {job}")
    else:
        time.sleep(1)
