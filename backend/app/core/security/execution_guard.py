# app/core/security/execution_guard.py

from app.core.logger import logger


def validate_job_execution(job):
    """
    Phase 7.4 Stabilized Execution Guard

    Purpose:
    - Allow controlled execution of valid job types
    - Prevent unknown or malicious job types
    - Maintain observability via logging
    - Keep system extensible for future security policies
    """

    try:
        # Normalize job type
        job_type = (job.type or "").strip().lower()

        # Allowed job types (Phase 1 + current system)
        ALLOWED_TYPES = {
            "ai",
            "test",
            "default",
            "test_job",
            "system"
        }

        # 🔍 Validation check
        if job_type not in ALLOWED_TYPES:
            logger.warning(
                "execution_blocked",
                extra={
                    "job_id": str(job.id),
                    "job_type": job_type,
                    "allowed_types": list(ALLOWED_TYPES)
                }
            )
            raise Exception(f"Blocked job type: {job_type}")

        # ✅ Allow execution
        logger.info(
            "execution_allowed",
            extra={
                "job_id": str(job.id),
                "job_type": job_type
            }
        )

        return True

    except Exception as e:
        logger.error(
            "execution_guard_failure",
            extra={
                "job_id": str(getattr(job, "id", None)),
                "error": str(e)
            }
        )
        raise
