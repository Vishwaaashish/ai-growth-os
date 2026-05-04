from sqlalchemy import text
from datetime import datetime


def calculate_delta(before, after):
    delta_ctr = (after["ctr"] - before["ctr"])
    delta_roas = (after["roas"] - before["roas"])
    delta_cpa = (before["cpa"] - after["cpa"])  # lower CPA is better

    # weighted scoring
    score = (
        delta_roas * 2 +
        delta_ctr * 1 -
        delta_cpa * 1.5
    )

    return score


def update_policy_score(db, policy_id, delta_score):
    db.execute(text("""
        UPDATE policies
        SET 
            score = score + :delta,
            usage_count = usage_count + 1,
            last_used = NOW()
        WHERE id = :pid
    """), {
        "delta": delta_score,
        "pid": policy_id
    })


def store_feedback(db, creative_id, policy_id, before, after, delta_score):
    db.execute(text("""
        INSERT INTO policy_feedback (
            creative_id, policy_id,
            before_ctr, after_ctr,
            before_roas, after_roas,
            before_cpa, after_cpa,
            delta_score
        )
        VALUES (
            :cid, :pid,
            :b_ctr, :a_ctr,
            :b_roas, :a_roas,
            :b_cpa, :a_cpa,
            :delta
        )
    """), {
        "cid": creative_id,
        "pid": policy_id,
        "b_ctr": before["ctr"],
        "a_ctr": after["ctr"],
        "b_roas": before["roas"],
        "a_roas": after["roas"],
        "b_cpa": before["cpa"],
        "a_cpa": after["cpa"],
        "delta": delta_score
    })

    db.commit()
