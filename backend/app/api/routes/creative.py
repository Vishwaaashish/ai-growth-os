from fastapi import APIRouter
from app.core.creative.orchestrator.generation_orchestrator import generate_creatives

router = APIRouter()

@router.post("/generate/hooks")
def generate_hooks_api(product_id: str):
    generate_creatives(product_id)
    return {"status": "hooks_generated"}

@router.post("/generate/scripts")
def generate_scripts_api(product_id: str):
    generate_creatives(product_id)
    return {"status": "scripts_generated"}
