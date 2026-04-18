from app.db.session import SessionLocal
from app.models.job import Job


def get_job(job_id):
    db = SessionLocal()

    try:
        job = db.query(Job).filter(Job.id == job_id).first()
        return job

    finally:
        db.close()
