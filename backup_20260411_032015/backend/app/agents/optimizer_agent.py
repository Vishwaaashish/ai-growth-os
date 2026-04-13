from app.decision_engine import optimize_performance


class OptimizerAgent:

    def __init__(self, adapter):
        self.adapter = adapter

    async def execute(self, context):
        return await self.adapter.optimize_performance(context)
