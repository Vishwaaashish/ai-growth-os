import math


def compute_adaptive_weights(metrics):
    """
    Dynamically adjust weights based on policy performance.
    No DB writes. Pure function.
    """

    if not metrics:
        return {
            "success_weight": 0.5,
            "latency_weight": 0.2,
            "failure_penalty": 0.3
        }

    success_rate = metrics.get("success_rate", 0.0)
    failure_count = metrics.get("failure_count", 0)
    total_runs = metrics.get("total_runs", 1)
    avg_latency = metrics.get("avg_latency", 0.0)

    failure_rate = failure_count / max(total_runs, 1)

    # --- Adaptive Logic ---

    # Increase success weight if success is high
    success_weight = 0.4 + (0.6 * success_rate)

    # Increase failure penalty if failures high
    failure_penalty = 0.2 + (0.8 * failure_rate)

    # Increase latency weight if latency high
    normalized_latency = min(avg_latency / 5000, 1.0)
    latency_weight = 0.1 + (0.4 * normalized_latency)

    return {
        "success_weight": round(success_weight, 3),
        "latency_weight": round(latency_weight, 3),
        "failure_penalty": round(failure_penalty, 3)
    }
