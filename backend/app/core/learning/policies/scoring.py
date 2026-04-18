import time
import math
import logging

from app.core.config.scoring_config import SCORING_CONFIG
from app.core.learning.agents.agent_metrics import agent_scores

logger = logging.getLogger(__name__)


# -----------------------------
# 🔷 METRICS VALIDATION
# -----------------------------
def validate_metrics(metrics):
    if not isinstance(metrics, dict):
        return {}

    validated = {}
    bounds = SCORING_CONFIG["bounds"]

    for key, (min_val, max_val) in bounds.items():

        value = metrics.get(key)

        # handle None / invalid
        if value is None or not isinstance(value, (int, float)):
            value = min_val

        # clamp
        value = max(min_val, min(max_val, value))

        validated[key] = value

    return validated


# -----------------------------
# 🔷 NORMALIZATION
# -----------------------------
def normalize(metric, value):
    min_val, max_val = SCORING_CONFIG["bounds"][metric]

    if max_val - min_val == 0:
        return 0.0

    return (value - min_val) / (max_val - min_val)


# -----------------------------
# 🔷 RECENCY DECAY
# -----------------------------
def compute_recency_factor(last_used_timestamp):

    if not last_used_timestamp:
        return 1.0  # no decay

    current_time = time.time()
    delta = current_time - last_used_timestamp

    decay_lambda = SCORING_CONFIG["recency"]["decay_lambda"]
    min_factor = SCORING_CONFIG["recency"]["min_factor"]

    factor = math.exp(-decay_lambda * delta)

    return max(min_factor, factor)


# -----------------------------
# 🔷 CORE SCORE (NEW)
# -----------------------------
def compute_score(metrics, last_used_timestamp):

    metrics = validate_metrics(metrics)

    weights = SCORING_CONFIG["weights"]

    success_rate = metrics.get("success_rate", 0.5)
    latency = metrics.get("avg_latency", 200)

    # normalize
    success_norm = normalize("success_rate", success_rate)

    latency_norm = normalize("avg_latency", latency)
    latency_score = 1 - latency_norm  # inverse

    base_score = (
        weights["success_rate"] * success_norm +
        weights["latency"] * latency_score
    )

    # apply recency
   # recency_factor = compute_recency_factor(last_used_timestamp)
   # final_score = base_score * recency_factor

    agent_boost = agent_scores.get(policy.get("agent_name", "default"), 1)

    final_score = score * agent_boost

    return final_score


# -----------------------------
# 🔷 MAIN WRAPPER (DO NOT BREAK)
# -----------------------------
def compute_policy_score(policy, metrics):
    try:
        success_rate = metrics.get("success_rate", 0)
        avg_latency = metrics.get("avg_latency", 1)
        failure_count = metrics.get("failure_count", 0)
        total_runs = metrics.get("total_runs", 1)

        failure_rate = failure_count / max(total_runs, 1)

        weights = policy.get("weights", {
            "success_weight": 0.7,
            "latency_weight": 0.1,
            "failure_penalty": 0.6
        })

        score = (
            success_rate * weights["success_weight"]
            - avg_latency * weights["latency_weight"]
            - failure_rate * weights["failure_penalty"]
        )
        # ✅ PREVENT NEGATIVE COLLAPSE
        score = max(score, 0.01)
        return score

    except Exception as e:
        print(f"Scoring error: {str(e)}")
        return 0
