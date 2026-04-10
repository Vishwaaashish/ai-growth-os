from app.decision_engine import decision_engine


class DecisionAdapter:

    async def scale_up(self, context):
        return decision_engine.scale_up()

    async def restart_failed_jobs(self, context):
        return decision_engine.restart_worker()

    async def optimize_performance(self, context):
        return decision_engine.optimize_latency()
