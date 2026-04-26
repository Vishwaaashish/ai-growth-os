# app/core/observability/failures.py

from app.core.logger import logger


def log_failure(data: dict):
    try:
        logger.error(
            "system_failure",
            extra={
                "failure": data
            }
        )
    except Exception as e:
        # fallback to avoid crash loop
        logger.error(
            "failure_logging_error",
            extra={
                "error": str(e),
                "original_failure": data
            }
        )
