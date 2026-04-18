import logging

logger = logging.getLogger("security")

def log_security_event(event_type, details):
    logger.warning({
        "type": "security_event",
        "event": event_type,
        "details": details
    })

def log_failure_event(job_id, error):
    logger.error({
        "type": "failure_event",
        "job_id": job_id,
        "error": error
    })
