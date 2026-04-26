from app.core.logger import logger

agent_scores = {}

def update_agent_score(agent_name, success):
    global agent_scores

    # ✅ SAFE INIT (CRITICAL FIX)
    if agent_name not in agent_scores:
        agent_scores[agent_name] = 1.0

    if success:
        agent_scores[agent_name] *= 1.05
    else:
        agent_scores[agent_name] *= 0.95

    # ✅ HARD CLAMP (STABILITY)
    agent_scores[agent_name] = max(0.1, min(agent_scores[agent_name], 10.0))

    logger.info("agent_score", extra={
        "agent": agent_name,
        "score": agent_scores[agent_name]
    })
