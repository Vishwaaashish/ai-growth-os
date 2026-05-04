def execute_action(creative_id, decision):

    if decision == "scale":
        return {
            "creative_id": creative_id,
            "action": "scale_creative",
            "status": "simulated"
        }

    elif decision == "kill":
        return {
            "creative_id": creative_id,
            "action": "pause_creative",
            "status": "simulated"
        }

    else:
        return {
            "creative_id": creative_id,
            "action": "no_action",
            "status": "skipped"
        }
