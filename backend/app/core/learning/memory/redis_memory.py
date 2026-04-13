import redis

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

def push_learning_event(data):
    r.xadd("learning:stream", data)

def get_recent_events(agent_id):
    return r.lrange(f"learning:buffer:{agent_id}", 0, 50)
