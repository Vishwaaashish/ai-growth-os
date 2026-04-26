def build_context(job, payload, db):
    """
    Build structured context for intelligence layer
    """

    return {
        "job_type": job.type,
        "payload": payload,
        "tenant_id": job.tenant_id,
        "timestamp": str(job.created_at)
    }
