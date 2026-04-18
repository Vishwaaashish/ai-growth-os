import time

last_request_time = {}


def allow_request(client_id):
    now = time.time()

    if client_id in last_request_time:
        if now - last_request_time[client_id] < 1:
            return False

    last_request_time[client_id] = now
    return True
