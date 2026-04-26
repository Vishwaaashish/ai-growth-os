import requests
import os

META_ACCESS_TOKEN = os.getenv("META_ACCESS_TOKEN")
AD_ACCOUNT_ID = os.getenv("META_AD_ACCOUNT_ID")

BASE_URL = "https://graph.facebook.com/v19.0"

def fetch_campaigns():
    url = f"{BASE_URL}/act_{AD_ACCOUNT_ID}/campaigns"
    params = {
        "fields": "id,name,status",
        "access_token": META_ACCESS_TOKEN
    }

    return requests.get(url, params=params).json()


def fetch_insights(campaign_id):
    url = f"{BASE_URL}/{campaign_id}/insights"
    params = {
        "fields": "impressions,clicks,spend",
        "access_token": META_ACCESS_TOKEN
    }

    return requests.get(url, params=params).json()
