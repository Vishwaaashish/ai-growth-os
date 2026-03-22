from fastapi import FastAPI
from app.api.routes import command_routes
from app.services.n8n_trigger import trigger_n8n
import logging

# -------------------------------
# LOGGING CONFIG (PRODUCTION)
# -------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)

# -------------------------------
# FASTAPI INIT
# -------------------------------
app = FastAPI(
    title="AI Growth OS Backend",
    version="1.0.0"
)

# -------------------------------
# ROUTES
# -------------------------------
app.include_router(command_routes.router)

# -------------------------------
# HEALTH CHECK
# -------------------------------
@app.get("/")
def health_check():
    return {"status": "AI Backend Running"}

# -------------------------------
# TEST N8N INTEGRATION
# -------------------------------
@app.get("/test-n8n")
def test_n8n():
    payload = {
        "event": "command.completed",
        "command_id": "test123",
        "status": "completed",
        "result": {"message": "Hello from backend"}
    }

    success = trigger_n8n(payload)

    if success:
        return {"status": "sent to n8n"}
    else:
        return {"status": "failed"}
