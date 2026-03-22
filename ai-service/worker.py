import redis
from rq import Worker, Queue

redis_conn = redis.Redis(host='localhost', port=6379)

if __name__ == '__main__':
    worker = Worker([Queue(connection=redis_conn)])
    worker.work()
