import requests

def run_automation(payload: dict):
    webhook_url = "http://localhost:5678/webhook/test"

    try:
        response = requests.post(webhook_url, json=payload)

        return {
            "status": "success",
            "type": "automation",
            "data": response.json()
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e)
        }
