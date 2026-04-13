import json
import time
import redis
from sqlalchemy.orm import Session
from sqlalchemy import text
from app.db.session import SessionLocal


r = redis.Redis(host="localhost", port=6379, decode_responses=True)

STREAM_KEY = "learning:stream"


def process_event(event_data: dict, db: Session):
    try:
        agent_id = event_data.get("agent_id")
        result = event_data.get("result")
        latency = event_data.get("metrics", {}).get("latency", 0)

        # 🔷 SIMPLE PATTERN (Phase 6.1 baseline)
        pattern_type = "success_pattern" if result == "success" else "failure_pattern"

        confidence_score = 1.0 if result == "success" else 0.5

        db.execute(
            text("""
                INSERT INTO learning_insights (agent_id, pattern_type, pattern_data, confidence_score)
                VALUES (:agent_id, :pattern_type, :pattern_data, :confidence_score)
             """),
             {
                "agent_id": agent_id,
                "pattern_type": pattern_type,
                "pattern_data": json.dumps(event_data),
                "confidence_score": confidence_score,
             }
        )
        db.commit()

        print("✅ Insight stored:", pattern_type)

    except Exception as e:
        print("❌ Processor Error:", str(e))


def run_processor():
    print("🚀 Learning Processor Started...")

    last_id = "0"

    while True:
        try:
            response = r.xread({STREAM_KEY: last_id}, block=5000)

            if not response:
                continue

            for stream_name, messages in response:
                for message_id, message in messages:

                    raw_data = message.get("data")

                    if not raw_data:
                        continue

                    event_data = json.loads(raw_data)

                    db = SessionLocal()
                    process_event(event_data, db)
                    db.close()

                    last_id = message_id

        except Exception as e:
            print("❌ Stream Error:", str(e))
            time.sleep(2)
