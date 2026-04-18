AGENTS = {
    "efficiency": {
        "description": "Optimize latency and performance",
        "priority_range": [1, 3],
        "weight_strategy": "latency_inverse"
    },
    "reliability": {
        "description": "Maximize success rate",
        "priority_range": [4, 6],
        "weight_strategy": "success_rate"
    },
    "explorer": {
        "description": "Explore new strategies",
        "priority_range": [1, 2, 3, 4, 5],
        "weight_strategy": "random"
    }
}
