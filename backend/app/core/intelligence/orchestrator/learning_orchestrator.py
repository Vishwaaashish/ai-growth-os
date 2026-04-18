from app.core.intelligence.evolution.evolution_engine import evolve_policies


def run_learning_cycle():
    try:
        evolve_policies()
    except Exception as e:
        print(f"Learning cycle failed: {str(e)}")
