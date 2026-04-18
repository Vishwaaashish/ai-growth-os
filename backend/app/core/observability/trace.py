import uuid
import time

def start_trace():
    return {
        "trace_id": str(uuid.uuid4()),
        "start_time": time.time()
    }

def end_trace(trace):
    trace["duration"] = round(time.time() - trace["start_time"], 4)
    return trace

