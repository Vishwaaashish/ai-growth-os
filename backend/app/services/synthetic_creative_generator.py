import random
import uuid

def generate_synthetic_creatives(n=5):
    creatives = []

    for _ in range(n):
        ctr = round(random.uniform(0.5, 5.0), 2)
        roas = round(random.uniform(0.5, 6.0), 2)
        cpa = round(random.uniform(50, 300), 2)

        creatives.append({
            "creative_id": str(uuid.uuid4()),
            "ctr": ctr,
            "roas": roas,
            "cpa": cpa
        })

    return creatives
