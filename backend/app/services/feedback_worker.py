from sqlalchemy import text
from app.db.session import SessionLocal
from datetime import datetime
from app.services.policy_confidence import compute_confidence


# =========================
# NORMALIZATION FUNCTION
# =========================
def normalize_delta(delta):
    MAX_DELTA = 10
    MIN_DELTA = -10

    delta = max(min(delta, MAX_DELTA), MIN_DELTA)
    return delta / 10


def process_feedback():
    db = SessionLocal()

    try:
        rows = db.execute(text("""
            SELECT *
            FROM policy_feedback_pending
            WHERE created_at < NOW() - INTERVAL '2 minutes'
            LIMIT 20
        """)).fetchall()

        for r in rows:

            # =========================
            # FETCH LATEST METRICS
            # =========================
            latest = db.execute(text("""
                SELECT ctr, roas, cpa
                FROM creative_metrics
                WHERE creative_id = :cid
                ORDER BY updated_at DESC
                LIMIT 1
            """), {"cid": r.creative_id}).fetchone()

            if not latest:
                continue

            after_ctr = float(latest.ctr or 0)
            after_roas = float(latest.roas or 0)
            after_cpa = float(latest.cpa or 0)

            # =========================
            # RAW DELTA
            # =========================
            raw_delta = (
                (after_ctr - (r.before_ctr or 0)) * 0.3 +
                (after_roas - (r.before_roas or 0)) * 0.5 -
                (after_cpa - (r.before_cpa or 0)) * 0.2
            )

            # =========================
            # NORMALIZED DELTA
            # =========================
            delta = normalize_delta(raw_delta)

            print(f"[RL-NORMALIZED] raw={raw_delta:.4f} → normalized={delta:.4f}")

            # =========================
            # STORE FEEDBACK
            # =========================
            db.execute(text("""
                INSERT INTO policy_feedback (
                    creative_id,
                    policy_id,
                    before_ctr,
                    after_ctr,
                    before_roas,
                    after_roas,
                    before_cpa,
                    after_cpa,
                    delta_score,
                    created_at
                ) VALUES (
                    :cid,
                    :pid,
                    :bctr,
                    :actr,
                    :broas,
                    :aroas,
                    :bcpa,
                    :acpa,
                    :delta,
                    NOW()
                )
            """), {
                "cid": r.creative_id,
                "pid": r.policy_id,
                "bctr": r.before_ctr,
                "actr": after_ctr,
                "broas": r.before_roas,
                "aroas": after_roas,
                "bcpa": r.before_cpa,
                "acpa": after_cpa,
                "delta": delta
            })

            # =========================
            # UPDATE POLICY SCORE
            # =========================
            db.execute(text("""
                UPDATE policies
                SET 
                    score = score + (:delta * 0.3),
                    usage_count = usage_count + 1,
                    last_used = NOW()
                WHERE id = :pid
            """), {
                "delta": delta,
                "pid": r.policy_id
            })

            # =========================
            # UPDATE SUCCESS / FAILURE
            # =========================
            if delta > 0:
                db.execute(text("""
                    UPDATE policies
                    SET success_count = success_count + 1
                    WHERE id = :pid
                """), {"pid": r.policy_id})
            else:
                db.execute(text("""
                    UPDATE policies
                    SET failure_count = failure_count + 1
                    WHERE id = :pid
                """), {"pid": r.policy_id})

            # =========================
            # RECALCULATE CONFIDENCE
            # =========================
            row = db.execute(text("""
                SELECT success_count, failure_count
                FROM policies
                WHERE id = :pid
            """), {"pid": r.policy_id}).fetchone()

            confidence = compute_confidence(
                row.success_count,
                row.failure_count
            )

            db.execute(text("""
                UPDATE policies
                SET confidence = :conf
                WHERE id = :pid
            """), {
                "conf": confidence,
                "pid": r.policy_id
            })

            # =========================
            # DELETE PENDING
            # =========================
            db.execute(text("""
                DELETE FROM policy_feedback_pending
                WHERE id = :id
            """), {"id": r.id})

            print(f"[RL] Policy {r.policy_id} updated | confidence={confidence:.4f}")

        db.commit()

    except Exception as e:
        print("[FEEDBACK ERROR]", str(e))

    finally:
        db.close()
