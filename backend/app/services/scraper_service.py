import requests

def run_scraper(payload: dict):
    url = payload.get("url")

    if not url:
        return {"error": "No URL provided"}

    try:
        res = requests.get(url)

        return {
            "status": "success",
            "type": "scraper",
            "status_code": res.status_code
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e)
        }
