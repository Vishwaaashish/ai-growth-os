from app.core.integrations.meta.meta_client import fetch_ad_metrics
from app.core.integrations.meta.mapper import transform_meta_metrics
from app.core.testing.metrics_ingestor import store_creative_metrics


def sync_meta_data(ad_account_id: str):
    """
    Full pipeline: Meta → DB
    """

    raw = fetch_ad_metrics(ad_account_id)
    transformed = transform_meta_metrics(raw)
    store_creative_metrics(transformed)
