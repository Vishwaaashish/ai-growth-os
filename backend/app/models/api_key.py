from sqlalchemy import Column, String, Integer, DateTime
from datetime import datetime
from app.db.base import Base


class APIKey(Base):
    __tablename__ = "api_keys"

    key = Column(String, primary_key=True, index=True)
    tenant_id = Column(String, index=True)
    quota = Column(Integer, default=1000)
    used = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow)
