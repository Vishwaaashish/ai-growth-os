import razorpay
from app.core.config.config import settings

client = razorpay.Client(
    auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET)
)


def create_order(amount: int, currency="INR"):
    order = client.order.create({
        "amount": amount * 100,  # paise
        "currency": currency,
        "payment_capture": 1
    })
    return order
