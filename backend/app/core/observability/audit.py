from app.core.observability.logger import get_logger

audit_logger = get_logger("audit")

def log_audit(event_type: str, data: dict):
    audit_logger.info({
        "type": "audit",
        "event": event_type,
        "data": data
    })
