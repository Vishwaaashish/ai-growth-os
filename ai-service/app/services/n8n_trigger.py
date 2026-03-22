import requests
import logging
import time

logger = logging.getLogger(__name__)

N8N_WEBHOOK_URL = "http://localhost:5678/webhook-test/ai-event"


def trigger_n8n(payload: dict):
    for attempt in range(3):
        try:
            response = requests.post(
                N8N_WEBHOOK_URL,
                json=payload,
                timeout=5
            )

            response.raise_for_status()

            logger.info(f"n8n triggered successfully: {payload}")
            return True

        except requests.exceptions.RequestException as e:
            logger.error(f"Attempt {attempt+1} failed: {e}")
            time.sleep(1)

    logger.critical("n8n trigger failed after retries")
    return False
