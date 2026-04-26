import requests
import os

META_ACCESS_TOKEN = os.getenv("META_ACCESS_TOKEN")
META_API_VERSION = "v19.0"


def create_meta_ad(ad_account_id: str, creative_name: str):
    """
    Create a basic Meta Ad (simplified)
    """

    url = f"https://graph.facebook.com/{META_API_VERSION}/act_{ad_account_id}/ads"

    payload = {
        "name": creative_name,
        "status": "PAUSED",
        "access_token": META_ACCESS_TOKEN
    }

    response = requests.post(url, data=payload)

    if response.status_code != 200:
        raise Exception(f"Meta Ad Creation Failed: {response.text}")

    return response.json().get("id")
