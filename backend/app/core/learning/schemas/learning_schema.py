from pydantic import BaseModel
from typing import Dict, Any


class FeedbackSchema(BaseModel):
    agent_id: str
    action_id: str
    state: Dict[str, Any]
    action: Dict[str, Any]
    result: str
    metrics: Dict[str, Any]


class FeatureSchema(BaseModel):
    failure_rate: float
    avg_latency: float
    error_types: list


class PolicySchema(BaseModel):
    agent_type: str
    condition: Dict[str, Any]
    recommended_action: Dict[str, Any]
    weight: float
    approval_status: str
