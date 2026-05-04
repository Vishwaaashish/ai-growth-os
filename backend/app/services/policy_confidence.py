import math

def compute_confidence(success_count, failure_count):
    total = success_count + failure_count

    if total == 0:
        return 0.1  # low confidence initially

    success_rate = success_count / total

    # confidence grows with usage but stabilizes
    confidence = success_rate * (1 - math.exp(-total / 10))

    return float(confidence)
