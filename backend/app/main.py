from fastapi import FastAPI
from app.api.router import router

app = FastAPI()

@app.get("/")
def root():
    return {"message": "AI Growth OS Running"}

app.include_router(router)
