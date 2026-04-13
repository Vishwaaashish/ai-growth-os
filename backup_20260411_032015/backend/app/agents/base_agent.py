from abc import ABC, abstractmethod


class BaseAgent(ABC):
    def __init__(self, redis_client, decision_engine):
        self.redis = redis_client
        self.decision_engine = decision_engine

    @abstractmethod
    async def execute(self, context: dict):
        pass
