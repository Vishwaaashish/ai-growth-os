@router.post("/approve_policy/{policy_id}")
def approve_policy(policy_id: int):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        UPDATE policies
        SET approval_status = 'approved'
        WHERE id = %s
    """, (policy_id,))

    conn.commit()
    return {"status": "approved"}


@router.post("/reject_policy/{policy_id}")
def reject_policy(policy_id: int):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        UPDATE policies
        SET approval_status = 'rejected'
        WHERE id = %s
    """, (policy_id,))

    conn.commit()
    return {"status": "rejected"}
