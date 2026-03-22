from app.database.models import Command
from app.database.connection import SessionLocal

def execute_command(data):
    db = SessionLocal()

    try:
        command = Command(
            user_id=data.user_id,
            input_text=data.input_text,
            output_text=f"Processed: {data.input_text}",
            status="completed"
        )

        db.add(command)
        db.commit()
        db.refresh(command)

        return command

    except Exception as e:
        db.rollback()
        raise e

    finally:
        db.close()
