def validate_metrics(success, latency):
    if latency < 0 or latency > 10000:
        return False

    if success not in [True, False]:
        return False

    return True
