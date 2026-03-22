import redis

r = redis.Redis(
    host='127.0.0.1',  # keep this
    port=6379,
    decode_responses=True
)
