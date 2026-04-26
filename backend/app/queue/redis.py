from app.core.config.config import settings
import redis
from rq import Queue

redis_conn = redis.Redis(
    host=settings.REDIS_HOST,
    port=settings.REDIS_PORT,
    db=0,
    decode_responses=False,  # ✅ DO NOT CHANGE
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
