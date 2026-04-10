from app.decision_engine import restart_failed_jobs


class HealerAgent:

    def __init__(self, adapter):
        self.adapter = adapter

    async def execute(self, context):
        return await self.adapter.restart_failed_jobs(context)
