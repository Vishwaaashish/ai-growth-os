from fastapi import APIRouter
from sqlalchemy import text
from app.db.session import SessionLocal

router = APIRouter()


@router.get("/dashboard")
def get_dashboard():
    db = SessionLocal()

    try:
        # Total creatives
        total_creatives = db.execute(text("""
            SELECT COUNT(*) FROM creatives
        """)).scalar()

        # Top creatives
        top_creatives = db.execute(text("""
            SELECT creative_id, COUNT(*) as usage
            FROM creative_metrics
            GROUP BY creative_id
            ORDER BY usage DESC
            LIMIT 10
        """)).fetchall()

        # Avg performance
        performance = db.execute(text("""
            SELECT 
                AVG(ctr) as avg_ctr,
                AVG(roas) as avg_roas,
                AVG(cpa) as avg_cpa
            FROM creative_metrics
        """)).fetchone()

        return {
            "total_creatives": total_creatives,
            "top_creatives": [
                {"creative_id": r.creative_id, "usage": r.usage}
                for r in top_creatives
            ],
            "performance": {
                "avg_ctr": float(performance.avg_ctr or 0),
                "avg_roas": float(performance.avg_roas or 0),
                "avg_cpa": float(performance.avg_cpa or 0),
            }
        }

    finally:
        db.close()
