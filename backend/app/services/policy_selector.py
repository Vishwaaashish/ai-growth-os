from sqlalchemy import text
import random
from datetime import datetime, timezone
from app.services.policy_decay import apply_decay
import math

# =========================
# CONFIG
# =========================
EPSILON = 0.25  # soft exploration
FORCED_EXPLORATION = 0.30  # hard exploration

last_selected_policy_id = None


def select_policy(db, agent_type="test_job"):
    global last_selected_policy_id

    rows = db.execute(text("""
        SELECT id, agent_type, score, usage_count, last_used, confidence
        FROM policies
        WHERE agent_type = :at
    """), {"at": agent_type}).fetchall()

    if not rows:
        return None

    now = datetime.now(timezone.utc)
    scored = []

    # =========================
    # SCORING LOOP
    # =========================
    for r in rows:
        try:
            base_score = float(r.score or 0)

            # normalize time
            last_used = r.last_used
            if last_used and last_used.tzinfo is None:
                last_used = last_used.replace(tzinfo=timezone.utc)

            # decay
            decayed_score = apply_decay(base_score, last_used)
            safe_score = max(decayed_score, 0)

            # recency
            if last_used:
                age_seconds = (now - last_used).total_seconds()
                recency_bonus = 1 / (1 + age_seconds / 3600)
            else:
                recency_bonus = 0

            # usage penalty (log-based)
            usage = float(r.usage_count or 0)
            usage_penalty = 1 / (1 + math.log(usage + 1))

            # confidence
            confidence = float(r.confidence or 0.05)

            # base score
            final_score = (
                safe_score
                * (1 + 0.3 * recency_bonus)
                * usage_penalty
                * (0.5 + confidence)
            )

            # =========================
            # EXPLORATION BOOST (CRITICAL)
            # =========================

            if usage <= 1:
                final_score *= 5.0
            elif usage <= 3:
                final_score *= 3.5

            elif usage < 5:
                final_score *= 2.2
            elif usage < 10:
                final_score *= 1.5

            # =========================
            # DOMINANCE SUPPRESSION
            # =========================
            if (r.usage_count or 0) > 30:
                final_score *= 0.2
            elif (r.usage_count or 0) > 20:
                final_score *= 0.3
            elif (r.usage_count or 0) > 15:
                final_score *= 0.5

         # safety
            if math.isnan(final_score) or isinstance(final_score, complex):
                final_score = 0.0

            if usage == 0:
                final_score += 5

            scored.append((float(final_score), r))

            print(
                f"[POLICY DEBUG] id={r.id} | base={base_score:.2f} | "
                f"decayed={decayed_score:.2f} | recency={recency_bonus:.4f} | "
                f"usage={usage:.2f} | confidence={confidence:.4f} | final={final_score:.4f}"
            )

        except Exception as e:
            print(f"[POLICY ERROR] {str(e)}")

    if not scored:
        return None

    # =========================
    # MINIMUM POOL GUARANTEE
    # =========================
    filtered = [
        (s, r) for (s, r) in scored
        if float(r.confidence or 0) >= 0.005
    ]

    if len(filtered) < 5:
        print("[POOL FIX] Expanding to top 5")
        filtered = sorted(scored, key=lambda x: x[0], reverse=True)[:5]

    # shuffle for diversity
    random.shuffle(filtered)

    # =========================
    # SINGLE RANDOM FLOW (FIXED)
    # =========================
    rand_val = random.random()

    # =========================
    # FORCED EXPLORATION (HARD)
    # =========================
    if rand_val < FORCED_EXPLORATION:
        selected = random.choice([r for (_, r) in filtered])
        print(f"[FORCED EXPLORATION] {selected.id}")

    # =========================
    # EPSILON EXPLORATION
    # =========================
    elif rand_val < FORCED_EXPLORATION + EPSILON:
        candidates = [r for (_, r) in filtered if r.id != last_selected_policy_id]

        if not candidates:
            candidates = [r for (_, r) in filtered]

        selected = random.choice(candidates)
        print(f"[EXPLORATION] {selected.id}")

    # =========================
    # EXPLOITATION
    # =========================
    else:
        filtered.sort(key=lambda x: x[0], reverse=True)

        selected = None
        for (_, r) in filtered:
            if r.id != last_selected_policy_id:
                selected = r
                break

        if not selected:
            selected = filtered[0][1]

        print(f"[EXPLOITATION] {selected.id}")

    # =========================
    # TRACK LAST
    # =========================
    last_selected_policy_id = selected.id

    return {
        "id": selected.id,
        "agent_type": selected.agent_type
    }
