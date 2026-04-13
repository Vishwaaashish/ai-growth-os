import time

def compute_policy_score(policy, metrics=None):
    now = time.time()

    # 🔷 fallback if no metrics
    if not metrics:
        return policy.get("weight", 1)

    success = metrics.get("success_count", 0)
    failure = metrics.get("failure_count", 0)
    total = success + failure

    success_rate = success / total if total > 0 else 0.5
    latency = metrics.get("avg_latency", 1)

    latency_score = 1 / (1 + latency)

    confidence = policy.get("confidence", 0.5)
    priority = policy.get("priority", 1)

    # 🔥 AGGRESSIVE MODEL
    score = (
        0.6 * success_rate +
        0.2 * latency_score +
        0.1 * confidence +
        0.1 * priority
    )

    return round(score, 4)
