def generate_scripts(hooks, format="video"):
    scripts = []

    for h in hooks:
        content = f"{h['text']} → Here's how it works..."

        scripts.append({
            "hook_text": h["text"],
            "format": format,
            "content": content
        })

    return scripts
