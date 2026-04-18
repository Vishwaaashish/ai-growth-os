import logging
import sys
import json
from datetime import datetime


class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_record = {
            "timestamp": datetime.utcnow().isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "module": record.module,
            "function": record.funcName,
            "line": record.lineno,
            "message": record.getMessage(),
        }

        # ✅ Attach structured dict logs (core requirement)
        if isinstance(record.msg, dict):
            log_record.update(record.msg)

        # ✅ Attach trace_id if passed via extra
        if hasattr(record, "trace_id"):
            log_record["trace_id"] = record.trace_id

        # ✅ Attach job_id if exists
        if hasattr(record, "job_id"):
            log_record["job_id"] = record.job_id

        # ✅ Attach exception info safely
        if record.exc_info:
            log_record["exception"] = self.formatException(record.exc_info)

        return json.dumps(log_record)


def get_logger(name: str):
    logger = logging.getLogger(name)

    # Prevent duplicate handlers (important in FastAPI reload)
    if logger.handlers:
        return logger

    logger.setLevel(logging.INFO)

    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(JSONFormatter())

    logger.addHandler(handler)

    # Prevent duplicate logs from root logger
    logger.propagate = False

    return logger
