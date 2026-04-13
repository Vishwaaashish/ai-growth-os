from app.models.job import Job
from app.db.session import SessionLocal

from app.services.ai_service import run_ai
from app.services.automation_service import run_automation
from app.services.scraper_service import run_scraper

from app.queue.redis import default_queue, dead_queue

import json
import time


def execute_job(job_id: int):
    db = SessionLocal()

    try:
        job = db.query(Job).filter(Job.id == job_id).first()

        if not job:
            return {"error": "Job not found"}

        payload = json.loads(job.payload)

        job.status = "running"
        db.commit()

        # 🔹 EXECUTION
        if job.type == "ai":
            result = run_ai(payload)

        elif job.type == "automation":
            result = run_automation(payload)

        elif job.type == "scraper":
            result = run_scraper(payload)

        else:
            raise Exception("Unknown job type")

        job.status = "completed"
        job.result = str(result)

        db.commit()

        return {"status": "completed"}

    except Exception as e:
        db.rollback()

        job = db.query(Job).filter(Job.id == job_id).first()

        if job:
            job.retries += 1

            # 🔁 RETRY WITH DELAY (BACKOFF)
            if job.retries < job.max_retries:
                job.status = "retrying"
                db.commit()

                delay = job.retries * 2  # 2s, 4s, 6s
                time.sleep(delay)

                default_queue.enqueue("app.worker.tasks.run_job", job.id)

            else:
                # 🔴 MOVE TO DEAD QUEUE
                job.status = "failed"
                job.error = str(e)
                db.commit()

                dead_queue.enqueue("app.worker.tasks.run_job", job.id)

        return {"error": str(e)}

    finally:
        db.close()
