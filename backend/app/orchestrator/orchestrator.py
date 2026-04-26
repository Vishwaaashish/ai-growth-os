from app.agents.scaler_agent import ScalerAgent
from app.agents.healer_agent import HealerAgent
from app.agents.optimizer_agent import OptimizerAgent
from app.adapters.decision_adapter import DecisionAdapter
from app.core.logger import logger


class Orchestrator:
    def __init__(self, redis_client, decision_engine):
        self.redis = redis_client
        self.adapter = DecisionAdapter()

        self.agents = {
            "scale": ScalerAgent(self.adapter),
            "heal": HealerAgent(self.adapter),
            "optimize": OptimizerAgent(self.adapter),
        }

    async def handle(self, context):
        plan = []

        # DECISION LOGIC
        if context.get("queue_size", 0) > 5:
            plan.append("scale")

        if context.get("job_failures", 0) > 0:
            plan.append("heal")

        if context.get("avg_latency", 0) > 1:
            plan.append("optimize")

        results = []

        # EXECUTION
        for step in plan:
            agent = self.agents.get(step)

            if agent:
                result = await agent.execute(context)
                results.append({"step": step, "result": result})

        logger.info(f"PLAN: {plan}")
        logger.info(f"RESULT: {results}")

        return {
            "plan": plan,
            "results": results,
        }
