from app.models.job import Job
from app.db.session import SessionLocal

from app.services.ai_service import run_ai
from app.services.automation_service import run_automation
from app.services.scraper_service import run_scraper

from app.queue.redis import high_queue, default_queue, low_queue, dead_queue

from app.core.learning.collectors.feedback_collector import update_policy_metrics

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

        print(f"🚀 Executing job {job.id} | policy_id={job.policy_id}")

        start_time = time.time()

        # 🔷 EXECUTION
        if job.type == "ai":
            result = run_ai(payload)

        elif job.type == "automation":
            result = run_automation(payload)

        elif job.type == "scraper":
            result = run_scraper(payload)

        elif job.type == "test_agent":
            result = {"status": "test_success"}  # fallback test

        else:
            raise Exception("Unknown job type")

        latency = int((time.time() - start_time) * 1000)

        # 🔷 SUCCESS
        job.status = "completed"
        job.result = json.dumps(result)

        db.commit()

        # 🔥 CRITICAL FIX (THIS WAS MISSING / FAILING)
        if job.policy_id is not None:
            print(f"📊 Updating metrics for policy {job.policy_id}")
            update_policy_metrics(db, job.policy_id, True, latency)
            db.commit()

        return {"status": "completed"}

    except Exception as e:
        error_msg = str(e)
        print(f"❌ Job {job_id} failed: {error_msg}")

        db.rollback()

        job = db.query(Job).filter(Job.id == job_id).first()

        if job:
            job.status = "failed"
            job.error = error_msg
            db.commit()

            # 🔥 FAILURE METRICS FIX
            if job.policy_id is not None:
                print(f"📊 Updating FAILURE metrics for policy {job.policy_id}")
                update_policy_metrics(db, job.policy_id, False, 0)
                db.commit()

        return {"error": error_msg}

    finally:
        db.close()
