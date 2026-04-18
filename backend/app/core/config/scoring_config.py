SCORING_CONFIG = {
    "weights": {
        "success_rate": 0.6,
        "latency": 0.4
    },

    "bounds": {
        "success_rate": (0.0, 1.0),
        "avg_latency": (0.0, 1000.0)
    },

    "recency": {
        "decay_lambda": 0.0005,   # SAFE (slow decay)
        "min_factor": 0.7         # prevents score collapse
    }
}
