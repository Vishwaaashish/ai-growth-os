from redis import Redis
from rq import Queue

# Redis connection
redis_conn = Redis(host="localhost", port=6379)

# Queue
queue = Queue(connection=redis_conn)
