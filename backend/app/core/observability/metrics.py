import redis
import json

# Use same Redis as queue
redis_client = redis.Redis(host="localhost", port=6379, db=0)


# =========================
# COUNTER
# =========================
def increment(metric_name: str):
    redis_client.incr(metric_name)


# =========================
# TIMING
# =========================
def record_timing(metric_name: str, value: float):
    redis_client.rpush(metric_name, value)


# =========================
# FETCH METRICS
# =========================
def get_metrics():
    keys = redis_client.keys("*")

    result = {}

    for key in keys:
        key = key.decode()

        if redis_client.type(key) == b"string":
            result[key] = int(redis_client.get(key))

        elif redis_client.type(key) == b"list":
            values = redis_client.lrange(key, 0, -1)
            result[key] = [float(v) for v in values]

    return result
