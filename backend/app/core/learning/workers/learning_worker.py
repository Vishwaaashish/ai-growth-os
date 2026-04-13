import redis
import json

from app.core.learning.processors.pattern_analyzer import detect_patterns
from app.core.learning.processors.stream_processor import run_processor


if __name__ == "__main__":
    run_processor()

r = redis.Redis(decode_responses=True)

def run():
    while True:
        messages = r.xread({"learning:stream": "0"}, block=5000)

        for stream, events in messages:
            for event_id, data in events:
                events_batch = [json.loads(data)]
                
                features = extract_features(events_batch)
                patterns = detect_patterns(features)

                print("Patterns:", patterns)
