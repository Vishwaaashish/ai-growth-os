from fastapi import FastAPI
from app.api.routes import command_routes

app = FastAPI(
    title="AI Growth OS Backend",
    version="1.0.0"
)

# Include Routes
app.include_router(command_routes.router)

# Health Check
@app.get("/")
def health_check():
    return {"status": "AI Backend Running"}
