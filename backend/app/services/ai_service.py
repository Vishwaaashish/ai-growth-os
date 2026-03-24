def run_ai(payload: dict):
    prompt = payload.get("prompt", "")
    return f"AI processed: {prompt}"
