from sqlalchemy import text
from app.db.session import SessionLocal
import random


def select_top_creatives(limit=5):
    db = SessionLocal()

    try:
        results = db.execute(text("""
            SELECT creative_id, roas
            FROM creative_metrics
            ORDER BY roas DESC
            LIMIT 20
        """)).fetchall()

        if not results:
            return []

        # Convert to list
        creatives = [r.creative_id for r in results]

        # =========================
        # EXPLOITATION vs EXPLORATION
        # =========================

        exploit_ratio = 0.6  # 70% exploit, 30% explore

        if random.random() < exploit_ratio:
            # 🔥 EXPLOIT → top performers
            selected = creatives[:limit]

        else:
            # 🔥 EXPLORE → random selection from top pool
            selected = random.sample(
                creatives,
                min(limit, len(creatives))
            )

        return selected

    finally:
        db.close()
