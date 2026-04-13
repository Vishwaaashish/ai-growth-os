from sqlalchemy import text


def update_policy_metrics(db, policy_id: int, success: bool, latency: int):
    try:
        # 🔷 STEP 1: check if row exists
        existing = db.execute(
            text("SELECT * FROM policy_metrics WHERE policy_id = :pid"),
            {"pid": policy_id}
        ).fetchone()

        if existing:
            # 🔷 UPDATE
            db.execute(
                text("""
                UPDATE policy_metrics
                SET 
                    success_count = success_count + :success_inc,
                    failure_count = failure_count + :failure_inc,
                    avg_latency = (
                        (avg_latency * (success_count + failure_count) + :latency)
                        / (success_count + failure_count + 1)
                    ),
                    last_updated = CURRENT_TIMESTAMP
                WHERE policy_id = :pid
                """),
                {
                    "pid": policy_id,
                    "success_inc": 1 if success else 0,
                    "failure_inc": 0 if success else 1,
                    "latency": latency
                }
            )

        else:
            # 🔥 CRITICAL FIX → INSERT FIRST TIME
            db.execute(
                text("""
                INSERT INTO policy_metrics (
                    policy_id,
                    success_count,
                    failure_count,
                    avg_latency
                )
                VALUES (
                    :pid,
                    :success,
                    :failure,
                    :latency
                )
                """),
                {
                    "pid": policy_id,
                    "success": 1 if success else 0,
                    "failure": 0 if success else 1,
                    "latency": latency
                }
            )

        db.commit()

        print(f"📊 Metrics updated for policy {policy_id}")

    except Exception as e:
        print(f"❌ Metrics update failed: {str(e)}")
        db.rollback()
