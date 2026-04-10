import asyncio
import json
import redis
from app.services.automation_service import trigger_n8n

# Redis connection
redis_client = redis.Redis(host="localhost", port=6379, db=0)

QUEUE_NAME = "ai_jobs"


async def process_job(job_data):
    try:
        command = json.loads(job_data)

        print(f"[WORKER] Received job: {command}")

        # Simulate processing
        result = {"message": "Task executed successfully"}

        payload = {
            "command_id": command.get("id"),
            "status": "completed",
            "result": result
        }

        print(f"[WORKER] Sending to n8n: {payload}")

        response = await trigger_n8n(payload)

        print(f"[WORKER] n8n response: {response}")

    except Exception as e:
        print(f"[WORKER ERROR] {e}")


async def worker_loop():
    print("🚀 Worker started... waiting for jobs")

    while True:
        job = redis_client.blpop(QUEUE_NAME)  # blocking pop

        if job:
            _, job_data = job
            await process_job(job_data)

        await asyncio.sleep(0.1)


if __name__ == "__main__":
    asyncio.run(worker_loop())
