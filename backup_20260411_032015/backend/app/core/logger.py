import logging

logging.basicConfig(level=logging.INFO)

logger = logging.getLogger("ai_growth")


def log_event(message: str):
    logger.info(message)
