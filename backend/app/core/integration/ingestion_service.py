from app.db.session import SessionLocal
from sqlalchemy import text
from app.core.integration.meta_ads_client import fetch_campaigns, fetch_insights

def ingest_meta_data():
    db = SessionLocal()

    campaigns = fetch_campaigns().get("data", [])

    for c in campaigns:
        insights = fetch_insights(c["id"]).get("data", [])

        if not insights:
            continue

        i = insights[0]

        impressions = int(i.get("impressions", 0))
        clicks = int(i.get("clicks", 0))
        spend = float(i.get("spend", 0))

        ctr = (clicks / impressions) if impressions > 0 else 0
        cpa = (spend / clicks) if clicks > 0 else 0

        db.execute(text("""
            INSERT INTO campaign_metrics
            (campaign_id, impressions, clicks, spend, ctr, cpa)
            VALUES (:cid, :imp, :clk, :spend, :ctr, :cpa)
        """), {
            "cid": c["id"],
            "imp": impressions,
            "clk": clicks,
            "spend": spend,
            "ctr": ctr,
            "cpa": cpa
        })

    db.commit()
    db.close()
