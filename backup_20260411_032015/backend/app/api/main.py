from fastapi import FastAPI

from app.core.queue_metrics import start_queue_metrics
from app.api.routes import router
from app.api.metrics import router as metrics_router
from app.db.init_db import init

app = FastAPI(title="AI Growth OS")

# ---------------------------
# STARTUP HOOK
# ---------------------------


@app.on_event("startup")
def startup_event():
    init()
    start_queue_metrics()


# ---------------------------
# ROUTERS
# ---------------------------

app.include_router(router)
app.include_router(metrics_router)

# ---------------------------
# HEALTH
# ---------------------------


@app.get("/")
def root():
    return {"status": "running"}


@app.get("/health")
def health():
    return {"status": "ok"}
