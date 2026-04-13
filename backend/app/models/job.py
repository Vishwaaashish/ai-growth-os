from sqlalchemy import Column, Integer, String, Text
from app.db.base import Base


class Job(Base):
    __tablename__ = "jobs"

    id = Column(Integer, primary_key=True, index=True)
    type = Column(String)
    payload = Column(Text)
    status = Column(String)

    # retry + result handling
    retries = Column(Integer, default=0)
    result = Column(Text, nullable=True)
    error = Column(Text, nullable=True)

    # ✅ CRITICAL (THIS FIXES YOUR ISSUE)
    policy_id = Column(Integer, nullable=True)
