from sqlalchemy.orm import Session
from app.database.models import Command

def create_command(db: Session, user_id: str, input_text: str):
    command = Command(
        user_id=user_id,
        input_text=input_text,
        status="pending"
    )
    db.add(command)
    db.commit()
    db.refresh(command)
    return command
