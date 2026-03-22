from fastapi import APIRouter
from app.schemas.command import CommandCreate, CommandResponse
from app.services.command_service import execute_command

router = APIRouter()

@router.post("/execute", response_model=CommandResponse)
def execute(command: CommandCreate):
    return execute_command(command)
