from app.decision_engine import scale_up


class ScalerAgent:

    def __init__(self, adapter):
        self.adapter = adapter

    async def execute(self, context):
        return await self.adapter.scale_up(context)
