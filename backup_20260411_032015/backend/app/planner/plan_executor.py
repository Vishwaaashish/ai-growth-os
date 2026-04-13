class PlanExecutor:

    def __init__(self, orchestrator):
        self.orchestrator = orchestrator

    async def execute_plan(self, plan, context):
        results = []

        for step in plan:

            modified_context = context.copy()

            if step == "scale_up":
                modified_context["queue_size"] = 10

            elif step == "heal":
                modified_context["job_failures"] = 1

            elif step == "optimize":
                modified_context["avg_latency"] = 5

            result = await self.orchestrator.handle(modified_context)

            results.append({"step": step, "result": result})

        return results
