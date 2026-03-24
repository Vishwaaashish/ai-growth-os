from app.db.session import SessionLocal
from app.models.job import Job
import time

def execute_job(job_id: str):
    db = SessionLocal()

    try:
        job = db.query(Job).filter(Job.id == job_id).first()

        if not job:
            print(f"[WORKER] Job not found: {job_id}")
            return

        job.status = "running"
        db.commit()

        print(f"[WORKER] Executing job {job_id}")

        time.sleep(5)

        job.status = "completed"
        job.result = "Execution successful"
        db.commit()

        print(f"[WORKER] Completed job {job_id}")

    except Exception as e:
        job.status = "failed"
        job.result = str(e)
        db.commit()

        print(f"[WORKER] Failed job {job_id}: {e}")

    finally:
        db.close()
