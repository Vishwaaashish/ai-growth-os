from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database.connection import SessionLocal
from app.database.models import Command

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/execute")
def execute(command: str, db: Session = Depends(get_db)):

    db_command = Command(
        user_id="aashish",
        input_text=command,
        status="pending"
    )

    db.add(db_command)
    db.commit()
    db.refresh(db_command)

    # AI logic (existing)
    output = f"Processed command: {command}"

    db_command.output_text = output
    db_command.status = "completed"
    db.commit()

    return {
        "id": db_command.id,
        "output": output
    }
