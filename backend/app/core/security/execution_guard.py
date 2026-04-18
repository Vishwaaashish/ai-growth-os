def validate_job_execution(job):
    """
    Phase 7.4 Stabilization:
    Allow controlled execution while keeping security extensible
    """

    # ✅ Allowed job types (current system)
    allowed_types = {
        "test",
        "default",
        "test_job"   # ← IMPORTANT (your policy uses this)
    }

    if job.type not in allowed_types:
        raise Exception(f"Blocked job type: {job.type}")
