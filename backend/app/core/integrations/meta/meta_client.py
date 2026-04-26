import requests
import os

META_ACCESS_TOKEN = os.getenv("META_ACCESS_TOKEN")
META_API_VERSION = "v19.0"


def fetch_ad_metrics(ad_account_id: str):
    """
    Fetch performance metrics from Meta Ads API
    """

    url = f"https://graph.facebook.com/{META_API_VERSION}/act_{ad_account_id}/insights"

    params = {
        "access_token": META_ACCESS_TOKEN,
        "fields": ",".join([
            "ad_id",
            "ad_name",
            "impressions",
            "clicks",
            "spend",
            "actions"
        ]),
        "level": "ad",
        "limit": 100
    }

    response = requests.get(url, params=params)

    if response.status_code != 200:
        raise Exception(f"Meta API Error: {response.text}")

    return response.json().get("data", [])
