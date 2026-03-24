from app.db.session import SessionLocal
from app.models.job import Job
from app.services.ai_service import run_ai
from app.services.scraper_service import run_scraper
from app.services.automation_service import run_automation


def execute_job(job_id: str):
    db = SessionLocal()

    try:
        job = db.query(Job).filter(Job.id == job_id).first()

        if not job:
            print(f"Job not found: {job_id}")
            return

        job.status = "running"
        db.commit()

        if job.type == "ai":
            result = run_ai(job.payload)

        elif job.type == "scrape":
            result = run_scraper(job.payload)

        elif job.type == "automation":
            result = run_automation(job.payload)

        else:
            raise Exception("Unknown job type")

        job.status = "completed"
        job.result = result
        db.commit()

    except Exception as e:
        job.status = "failed"
        job.result = str(e)
        db.commit()

    finally:
        db.close()
