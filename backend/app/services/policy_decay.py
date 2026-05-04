from datetime import datetime, timezone

def apply_decay(score, last_used):
    if not last_used:
        return score

    # normalize timezone
    if last_used.tzinfo is None:
        last_used = last_used.replace(tzinfo=timezone.utc)

    now = datetime.now(timezone.utc)

    age_hours = (now - last_used).total_seconds() / 3600

    # ✅ CONTROLLED DECAY (NOT ZEROING)
    decay_factor = 1 / (1 + age_hours / 24)

    return score * decay_factor
