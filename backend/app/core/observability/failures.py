from app.core.observability.logger import get_logger

logger = get_logger("failure")

def log_failure(context):
    logger.error({
        "type": "failure_event",
        **context
    })
