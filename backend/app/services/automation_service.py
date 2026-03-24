import requests

def run_automation(payload: dict):
    webhook_url = "http://localhost:5678/webhook/test"
    response = requests.post(webhook_url, json=payload)
    return response.json()
