from app.core.config.config import settings

import redis
import json

from app.core.learning.processors.pattern_analyzer import detect_patterns
from app.core.learning.processors.stream_processor import run_processor
from app.core.logger import logger

if __name__ == "__main__":
    run_processor()

redis_client = redis.Redis(
    host=settings.REDIS_HOST,
    port=6379,
    decode_responses=True
)

def run():
    while True:
        messages = r.xread({"learning:stream": "0"}, block=5000)

        for stream, events in messages:
            for event_id, data in events:
                events_batch = [json.loads(data)]

                features = extract_features(events_batch)
                patterns = detect_patterns(features)

                logger.debug("patterns_data", extra={"data": patterns})
