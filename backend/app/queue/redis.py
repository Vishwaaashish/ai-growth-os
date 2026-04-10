import redis
from rq import Queue

# ---------------------------
# REDIS CONNECTION (FIXED)
# ---------------------------

redis_conn = redis.Redis(
    host="localhost",
    port=6379,
    db=0,
    decode_responses=False,  # ✅ CRITICAL (DO NOT CHANGE)
)

# ---------------------------
# MAIN QUEUES
# ---------------------------

high_queue = Queue("high", connection=redis_conn)
default_queue = Queue("default", connection=redis_conn)
low_queue = Queue("low", connection=redis_conn)

# ---------------------------
# DEAD LETTER QUEUE
# ---------------------------

dead_queue = Queue("dead", connection=redis_conn)
