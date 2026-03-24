def run_scraper(payload: dict):
    url = payload.get("url", "")
    return f"Scraped data from {url}"
