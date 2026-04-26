def generate_creative_id(brand, format, bucket, hook_id, version):
    return f"{brand}-{format}-{bucket}-{hook_id}-v{version}"
