import logging
from app.core.infra_manager import InfraManager

logging.basicConfig(level=logging.INFO)


class DecisionEngine:
    def __init__(self):
        self.infra = InfraManager()

    def scale_up(self):
        try:
            self.infra.scale(2)
            return {"action": "scale_up"}
        except Exception as e:
            return {"error": str(e)}

    def restart_worker(self):
        try:
            self.infra.restart()
            return {"action": "restart_worker"}
        except Exception as e:
            return {"error": str(e)}

    def optimize_latency(self):
        try:
            self.infra.optimize_cpu()
            containers = self.infra.get_worker_containers()
            return {
                "action": "optimize_latency",
                "containers": containers,
            }
        except Exception as e:
            return {"error": str(e)}


# SINGLE INSTANCE
decision_engine = DecisionEngine()


# ASYNC WRAPPERS (FOR AGENTS)


async def scale_up(context):
    return decision_engine.scale_up()


async def restart_failed_jobs(context):
    return decision_engine.restart_worker()


async def optimize_performance(context):
    return decision_engine.optimize_latency()
