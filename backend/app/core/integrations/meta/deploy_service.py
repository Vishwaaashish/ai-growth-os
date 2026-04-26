from sqlalchemy import text
from app.db.session import get_db
from app.core.integrations.meta.ad_creator import create_meta_ad


def deploy_creatives_to_meta(product_id: str, ad_account_id: str):
    """
    Deploy newly generated creatives to Meta Ads
    """

    db = next(get_db())

    creatives = db.execute(text("""
        SELECT id FROM creatives
        WHERE status = 'new'
    """)).fetchall()

    deployed = []

    for c in creatives:
        creative_id = c[0]

        try:
            ad_id = create_meta_ad(
                ad_account_id=ad_account_id,
                creative_name=f"creative_{creative_id}"
            )

            # store mapping
            db.execute(text("""
                INSERT INTO creative_ad_map (creative_id, ad_id)
                VALUES (:creative_id, :ad_id)
                ON CONFLICT (ad_id) DO NOTHING
            """), {
                "creative_id": creative_id,
                "ad_id": ad_id
            })

            # update creative status
            db.execute(text("""
                UPDATE creatives
                SET status = 'deployed'
                WHERE id = :creative_id
            """), {"creative_id": creative_id})

            deployed.append(creative_id)

        except Exception as e:
            print(f"Deployment failed for {creative_id}: {e}")

    db.commit()

    return deployed
