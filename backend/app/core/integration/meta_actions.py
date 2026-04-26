import requests
import os

TOKEN = os.getenv("META_ACCESS_TOKEN")

def pause_campaign(campaign_id):
    url = f"https://graph.facebook.com/v19.0/{campaign_id}"
    requests.post(url, data={
        "status": "PAUSED",
        "access_token": TOKEN
    })


def increase_budget(campaign_id, amount):
    url = f"https://graph.facebook.com/v19.0/{campaign_id}"
    requests.post(url, data={
        "daily_budget": amount,
        "access_token": TOKEN
    })
