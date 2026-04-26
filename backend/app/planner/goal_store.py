import json
from app.core.logger import logger

GOAL_KEY = "active_goal"


class GoalStore:

    def __init__(self, redis_client):
        self.redis = redis_client

    # =========================
    # SET GOAL
    # =========================
    def set_goal(self, goal: dict):
        """
        Stores goal in Redis
        """
        self.redis.set(GOAL_KEY, json.dumps(goal))

    # =========================
    # GET GOAL
    # =========================
    def get_goal(self):
        """
        Retrieves active goal
        """
        data = self.redis.get(GOAL_KEY)

        if not data:
            return None

        try:
            return json.loads(data)

        except Exception as e:
            logger.error(
                "goal_store_error",
                extra={"error": str(e)},
                exc_info=True
            )
            return None


    # =========================
    # CLEAR GOAL
    # =========================
    def clear_goal(self):
        """
        Removes active goal
        """
        self.redis.delete(GOAL_KEY)
