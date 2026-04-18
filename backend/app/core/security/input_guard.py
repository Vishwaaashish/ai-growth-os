def validate_job_input(data: dict):
    if "type" not in data:
        return False, "Missing job type"

    if "payload" not in data:
        return False, "Missing payload"

    if not isinstance(data["payload"], dict):
        return False, "Payload must be object"

    return True, None
