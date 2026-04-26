from app.core.config.config import settings

import redis

# =========================
# REDIS CLIENT (STANDARDIZED)
# =========================
redis_client = redis.Redis(
    host=settings.REDIS_HOST,
    port=6379,
    db=0,
    decode_responses=True  # ensures all responses are str
)

# =========================
# COUNTER
# =========================
def increment(metric_name: str, tenant_id: str = "global"):
    key = f"{metric_name}:{tenant_id}"   # ✅ ONLY THIS FORMAT
    redis_client.incr(key)

# =========================
# TIMING
# ========================
def record_timing(metric_name: str, value: float, tenant_id: str = "global"):
    key = f"{metric_name}:{tenant_id}"
    redis_client.rpush(key, value)

# =========================
# FETCH METRICS
# =========================
def get_metrics():
    keys = redis_client.keys("*")
    result = {}

    for key in keys:
        key_str = key.decode() if isinstance(key, bytes) else key

        key_type = redis_client.type(key)

        # normalize type
        if isinstance(key_type, bytes):
            key_type = key_type.decode()

        # STRING (counters)
        if key_type == "string":
            value = redis_client.get(key)
            try:
                result[key_str] = int(value)
            except:
                continue

        # LIST (timings)
        elif key_type == "list":
            values = redis_client.lrange(key, 0, -1)

            clean_values = []
            for v in values:
                try:
                    val = float(v.decode() if isinstance(v, bytes) else v)
                    clean_values.append(val)
                except:
                    continue

            result[key_str] = clean_values

    return result
