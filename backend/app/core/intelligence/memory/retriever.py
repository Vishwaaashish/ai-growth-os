from sqlalchemy import text

def get_recent_learning(policy_id, db, limit=5):
    result = db.execute(text("""
        SELECT outcome, latency
        FROM learning_memory
        WHERE policy_id = :pid
        ORDER BY created_at DESC
        LIMIT :limit
    """), {
        "pid": policy_id,
        "limit": limit
    })

    return [dict(row._mapping) for row in result]
