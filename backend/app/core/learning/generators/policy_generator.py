import random
from app.core.learning.agents.agent_config import AGENTS

def generate_policies_from_patterns(patterns):

    new_policies = []

    for agent_name, config in AGENTS.items():
        for p in patterns:

            success = p.get("success_rate", 0)
            latency = p.get("avg_latency", 1)

            # 🔥 smarter generation logic
            if agent_name == "efficiency":
                priority = random.choice([2, 3])
                weight = round(1.0 / (latency + 1), 2)

            elif agent_name == "reliability":
                priority = random.choice([4, 5, 6])
                weight = round(max(success * 3, 0.5), 2)

            elif agent_name == "explorer":
                priority = random.choice([1, 2, 3, 4, 5])
                weight = round(random.uniform(0.5, 2.0), 2)

            else:
                continue

            new_policies.append({
                "agent_type": "test_job",
                "agent_name": agent_name,
                "condition": {
                    "min_success_rate": round(success, 2),
                    "max_latency": round(latency, 2)
               },
                "action": {"priority": priority},
                "weight": weight
            })


    if not AGENTS:
        raise Exception("AGENTS config missing")

    return new_policies


