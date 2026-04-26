import random

def generate_hooks(product_id, n=50):
    base_hooks = [
        "This changed everything",
        "Nobody talks about this",
        "Hidden secret revealed",
        "Stop wasting money on ads",
        "This works in 24 hours"
    ]

    hooks = []

    for _ in range(n):
        text = random.choice(base_hooks)
        hooks.append({
            "product_id": product_id,
            "category": "generic",
            "text": text
        })

    return hooks
