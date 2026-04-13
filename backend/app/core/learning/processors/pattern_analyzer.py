def detect_patterns(features):
    patterns = []

    if features["failure_rate"] > 0.3:
        patterns.append("high_failure_rate")

    if features["avg_latency"] > 1000:
        patterns.append("latency_spike")

    return patterns
