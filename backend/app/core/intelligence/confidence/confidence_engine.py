def calculate_confidence(metrics):
    total = metrics.get("total_runs", 0)

    if total < 5:
        return 0.2
    elif total < 20:
        return 0.5
    elif total < 50:
        return 0.7
    else:
        return 0.9
