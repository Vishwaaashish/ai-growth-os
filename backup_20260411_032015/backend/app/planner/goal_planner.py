class GoalPlanner:

    def create_plan(self, goal: dict, context: dict):

        plan = []

        if goal["goal"] == "handle_load":
            if context["queue_size"] > goal["target"]:
                plan.append("scale_up")

        elif goal["goal"] == "reduce_failures":
            if context["job_failures"] > 0:
                plan.append("heal")

        elif goal["goal"] == "reduce_latency":
            if context["avg_latency"] > goal["target"]:
                plan.append("optimize")
                plan.append("scale_up")

        return plan
