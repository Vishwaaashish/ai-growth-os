from fastapi import APIRouter
from app.services.safety_guard import SAFETY_CONFIG

router = APIRouter()


@router.post("/kill-switch")
def toggle_kill_switch(state: bool):
    SAFETY_CONFIG["kill_switch"] = state
    return {"kill_switch": state}
