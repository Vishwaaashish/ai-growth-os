from app.db.session import get_db
from app.db.session import SessionLocal
from sqlalchemy import text
from app.core.logger import logger

from app.core.creative.hooks.hook_engine import generate_hooks
from app.core.creative.scripts.script_engine import generate_scripts
from app.core.integrations.meta.deploy_service import deploy_creatives_to_meta


def generate_creatives(product_id: str, ad_account_id="test_account", auto_deploy=False):
    db = SessionLocal()

    try:
        # =========================
        # STEP 1: GENERATE HOOKS
        # =========================
        hooks = generate_hooks(product_id)

        hook_ids = []

        for h in hooks:
            result = db.execute(text("""
                INSERT INTO hooks (product_id, category, text, score)
                VALUES (:product_id, :category, :text, :score)
                RETURNING id
            """), {
                "product_id": product_id,
                "category": h.get("category", "general"),
                "text": h.get("text"),
                "score": h.get("score", 0.1)
            }).fetchone()

            hook_ids.append(result[0])

        # =========================
        # STEP 2: GENERATE SCRIPTS
        # =========================
        scripts = generate_scripts(hooks[:10])

        script_ids = []

        for i, s in enumerate(scripts):
            result = db.execute(text("""
                INSERT INTO scripts (hook_id, format, content, version)
                VALUES (:hook_id, :format, :content, :version)
                RETURNING id
            """), {
                "hook_id": hook_ids[i],
                "format": s.get("format", "text"),
                "content": s.get("content"),
                "version": 1
            }).fetchone()

            script_ids.append(result[0])

        # =========================
        # STEP 3: CREATE CREATIVES
        # =========================
        creative_ids = []

        for sid in script_ids:
            result = db.execute(text("""
                INSERT INTO creatives (script_id, format, asset_url, status, score)
                VALUES (:script_id, 'image', NULL, 'generated', 0.1)
                RETURNING id
            """), {
                "script_id": sid
            }).fetchone()

            creative_ids.append(result[0])

        db.commit()

        logger.info("creative_generation_completed", extra={
            "product_id": product_id,
            "hooks": len(hooks),
            "scripts": len(scripts),
            "creatives": len(creative_ids)
        })

        # =========================
        # STEP 4: AUTO DEPLOY (CONTROLLED)
        # =========================
        if auto_deploy:
            try:
                deploy_creatives_to_meta(
                    product_id=product_id,
                    ad_account_id=ad_account_id
                )
            except Exception as e:
                logger.warning("meta_deploy_failed", extra={"error": str(e)})

        return creative_ids

    except Exception as e:
        db.rollback()
        logger.error("creative_generation_failed", extra={"error": str(e)}, exc_info=True)
        return []

    finally:
        db.close()


def map_creative_to_ad(creative_id, ad_id):
    db = next(get_db())

    try:
        db.execute(text("""
            INSERT INTO creative_ad_map (creative_id, ad_id)
            VALUES (:creative_id, :ad_id)
            ON CONFLICT (ad_id) DO NOTHING
        """), {
            "creative_id": creative_id,
            "ad_id": ad_id
        })

        db.commit()

    except Exception as e:
        db.rollback()
        logger.error("creative_ad_mapping_failed", extra={"error": str(e)})

    finally:
        db.close()
