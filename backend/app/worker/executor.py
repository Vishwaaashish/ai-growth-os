from app.models.job import Job
from app.db.session import SessionLocal

from app.services.ai_service import run_ai
from app.services.automation_service import run_automation
from app.services.scraper_service import run_scraper


def execute_job(job_id: str):
    db = SessionLocal()

    job = db.query(Job).filter(Job.id == job_id).first()

    if not job:
        return {"error": "Job not found"}

    try:
        if job.type == "ai":
            result = run_ai(job.payload)

        elif job.type == "automation":
            result = run_automation(job.payload)

        elif job.type == "scraper":
            result = run_scraper(job.payload)

        else:
            raise Exception("Unknown job type")

        job.status = "completed"
        job.result = result

    except Exception as e:
        job.status = "failed"
        job.error = str(e)

    db.commit()
    db.close()

    return {"status": job.status}
