from sqlalchemy import Column, Integer, String, Text, DateTime
from datetime import datetime
from app.db.base import Base


class Job(Base):
    __tablename__ = "jobs"

    id = Column(Integer, primary_key=True, index=True)

    type = Column(String, nullable=False)

    payload = Column(Text, nullable=False)

    status = Column(String, default="queued")

    result = Column(Text, nullable=True)

    error = Column(Text, nullable=True)

    # 🔴 NEW FIELDS
    priority = Column(String, default="default")  # high / default / low
    retries = Column(Integer, default=0)
    max_retries = Column(Integer, default=3)

    created_at = Column(DateTime, default=datetime.utcnow)
