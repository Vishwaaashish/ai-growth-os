def extract_features(events):
    total = len(events)

    failures = [e for e in events if e["result"] == "failure"]

    return {
        "failure_rate": len(failures) / total if total else 0,
        "avg_latency": sum(e["metrics"]["latency"] for e in events) / total,
        "error_types": list(set(e["metrics"].get("error") for e in failures))
    }
