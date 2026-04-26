from sqlalchemy import text
from app.db.session import SessionLocal
import json

def register_creatives(scripts):
    db = SessionLocal()

    try:
        for s in scripts:
            db.execute(text("""
                INSERT INTO creatives (script_id, format, asset_url, status)
                VALUES (:script_id, :format, :asset_url, :status)
            """), {
                "script_id": None,
                "format": s["format"],
                "asset_url": "pending",
                "status": "draft"
            })

        db.commit()

    finally:
        db.close()
