class AgentRouter:

    def route(self, context: dict) -> str:
        """
        Deterministic routing (priority-based)
        Priority: Healer > Scaler > Optimizer
        """

        if context.get("job_failures", 0) > 0:
            return "healer"

        if context.get("queue_size", 0) > 5:
            return "scaler"

        if context.get("avg_latency", 0) > 2:
            return "optimizer"

        return "none"
