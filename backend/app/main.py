from fastapi import FastAPI
from app.api.execute import router as execute_router

app = FastAPI()

# Health check endpoint
@app.get("/")
def root():
    return {"message": "AI Growth OS Backend Running"}

# Register execution route
app.include_router(execute_router)
