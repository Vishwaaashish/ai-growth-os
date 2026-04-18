import time

FAILURE_THRESHOLD = 5
COOLDOWN_TIME = 30  # seconds

failure_tracker = {}
circuit_state = {}


def record_failure(key):
    now = time.time()

    if key not in failure_tracker:
        failure_tracker[key] = []

    failure_tracker[key].append(now)

    # keep last 10 failures
    failure_tracker[key] = failure_tracker[key][-10:]

    if len(failure_tracker[key]) >= FAILURE_THRESHOLD:
        circuit_state[key] = now


def is_circuit_open(key):
    if key not in circuit_state:
        return False

    last_failure_time = circuit_state[key]

    if time.time() - last_failure_time < COOLDOWN_TIME:
        return True

    # reset after cooldown
    del circuit_state[key]
    failure_tracker[key] = []
    return False
