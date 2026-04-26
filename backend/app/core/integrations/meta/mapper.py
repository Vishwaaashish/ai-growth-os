from sqlalchemy import text
from app.db.session import get_db
from app.core.logger import logger

def get_creative_id_from_ad(ad_id):
    db = next(get_db())

    result = db.execute(text("""
        SELECT creative_id FROM creative_ad_map
        WHERE ad_id = :ad_id
        LIMIT 1
    """), {"ad_id": ad_id}).fetchone()

    return result[0] if result else None

def transform_meta_metrics(raw_data):

    transformed = []

    for ad in raw_data:

        ad_id = ad.get("ad_id")
        creative_id = get_creative_id_from_ad(ad_id)

        # =========================
        # UNMAPPED AD HANDLING
        # =========================
        if not creative_id:
            logger.warning(
                "unmapped_ad_detected",
                extra={"ad_id": ad_id}
            )
            continue

        impressions = int(ad.get("impressions", 0))
        clicks = int(ad.get("clicks", 0))
        spend = float(ad.get("spend", 0))

        ctr = (clicks / impressions) if impressions > 0 else 0
        cpa = spend / clicks if clicks > 0 else 0

        transformed.append({
            "creative_id": creative_id,
            "ctr": ctr,
            "cpa": cpa,
            "roas": 0,
            "frequency": 0
        })

    return transformed
