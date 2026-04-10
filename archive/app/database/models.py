from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.orm import declarative_base

Base = declarative_base()

class Command(Base):
    __tablename__ = "commands"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(100))
    input_text = Column(Text, nullable=False)
    output_text = Column(Text)
    status = Column(String(50), default="pending")
