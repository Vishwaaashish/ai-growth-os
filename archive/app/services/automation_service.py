import httpx
import os

N8N_WEBHOOK_URL = os.getenv(
    "N8N_WEBHOOK_URL",
    "http://localhost:5678/webhook-test/ai-event"
)


async def trigger_n8n(payload: dict):
    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            response = await client.post(N8N_WEBHOOK_URL, json=payload)
            return response.status_code
    except Exception as e:
        print("[n8n ERROR]:", e)
        return None
