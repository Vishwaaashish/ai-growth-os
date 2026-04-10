from app.database.connection import SessionLocal
from app.database.models import Command

def process_command(command_id: int):
    db = SessionLocal()

    command = db.query(Command).filter(Command.id == command_id).first()

    if not command:
        return

    # Simulated heavy processing
    output = f"Processed (async): {command.input_text}"

    command.output_text = output
    command.status = "completed"

    db.commit()
    db.close()

    return output
