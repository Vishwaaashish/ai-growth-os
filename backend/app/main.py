from fastapi import FastAPI, Request
from fastapi.responses import Response
from prometheus_client import (
    Counter,
    Gauge,
    Histogram,
    generate_latest,
    CONTENT_TYPE_LATEST,
)

import subprocess
import random
import logging
import time
import json

# =========================
# IMPORTS (FIXED)
# =========================
from app.core.redis_client import redis_client
from app.decision_engine import decision_engine
from app.orchestrator.orchestrator import Orchestrator

# ✅ PHASE 5 IMPORTS
from app.planner.goal_planner import GoalPlanner
from app.planner.plan_executor import PlanExecutor
from app.planner.goal_store import GoalStore

from app.api.routes.metrics import router as metrics_router
from app.api.routes.job import router as job_router

app = FastAPI()

app.include_router(job_router)
app.include_router(metrics_router)

logging.basicConfig(level=logging.INFO)

# =========================
# METRICS
# =========================
queue_size = Gauge("queue_size", "Current queue size")
job_failure_total = Counter("job_failure_total", "Total failed jobs")
worker_execution_time_seconds = Histogram(
    "worker_execution_time_seconds", "Worker execution time"
)

# =========================
# CONFIG
# =========================
WORKER_SERVICE = "worker"

# =========================
# STATE MANAGEMENT
# =========================
STATE_KEY = "system_state"


def load_state():
    data = redis_client.get(STATE_KEY)
    return json.loads(data) if data else {"actions": []}


def save_state(state):
    redis_client.set(STATE_KEY, json.dumps(state))


def log_action(action, outcome):
    state = load_state()
    state["actions"].append(
        {"action": action, "outcome": outcome, "timestamp": time.time()}
    )
    save_state(state)


# =========================
# ORCHESTRATOR INIT
# =========================
orchestrator = Orchestrator(redis_client, decision_engine)

# =========================
# PHASE 5 INIT (GOAL SYSTEM)
# =========================
goal_store = GoalStore(redis_client)
goal_planner = GoalPlanner()
plan_executor = PlanExecutor(orchestrator)


# =========================
# METRICS ENDPOINT
# =========================
@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)


# =========================
# JOB PRODUCER
# =========================



# =========================
# SIMULATION (CONTROLLED TESTING)
# =========================
@app.post("/simulate")
async def simulate(request: Request):
    data = await request.json()

    # Set queue size
    queue = data.get("queue", 0)
    redis_client.delete("job_queue")
    for i in range(queue):
        redis_client.rpush("job_queue", f"job-{i}")

    # Set failures
    failures = data.get("failures", 0)
    job_failure_total._value.set(failures)

    # Set latency (mock)
    latency = data.get("latency", 0)
    redis_client.set("avg_latency", latency)

    return {
        "status": "simulated",
        "queue": queue,
        "failures": failures,
        "latency": latency,
    }


# =========================
# SELF OPTIMIZE (PHASE 4)
# =========================
@app.get("/self-optimize")
async def self_optimize():

    context = {
        "queue_size": redis_client.llen("job_queue"),
        "job_failures": int(job_failure_total._value.get()),
        "avg_latency": 0,
    }

    result = await orchestrator.handle(context)

    logging.info(f"ORCHESTRATOR: {result}")

    return result


# =========================
# WEBHOOK (ALERTMANAGER)
# =========================
@app.post("/webhook")
async def webhook(request: Request):
    data = await request.json()

    context = {
        "queue_size": redis_client.llen("job_queue"),
        "job_failures": int(job_failure_total._value.get()),
        "avg_latency": 0,
    }

    result = await orchestrator.handle(context)

    return {"orchestrator_result": result}


# =====================================================
# ================= PHASE 5 ENDPOINTS ==================
# =====================================================


# 9.1 SET GOAL
@app.post("/set-goal")
async def set_goal(request: Request):
    goal = await request.json()

    goal_store.set_goal(goal)

    return {"status": "goal_set", "goal": goal}


# 9.2 EXECUTE GOAL
@app.get("/execute-goal")
async def execute_goal():

    goal = goal_store.get_goal()

    if not goal:
        return {"status": "no_goal"}

    context = {
        "queue_size": redis_client.llen("job_queue"),
        "job_failures": int(job_failure_total._value.get()),
        "avg_latency": float(redis_client.get("avg_latency") or 0),
    }

    plan = goal_planner.create_plan(goal, context)

    results = await plan_executor.execute_plan(plan, context)

    return {"goal": goal, "plan": plan, "results": results}


# 9.3 CLEAR GOAL
@app.delete("/clear-goal")
def clear_goal():
    goal_store.clear_goal()
    return {"status": "cleared"}


# =========================
# HEALTH
# =========================
@app.get("/")
def health():
    return {"status": "ok"}

@app.get("/health")
def health_check():
    return {"status": "ok"}
