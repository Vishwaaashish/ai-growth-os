
import os


class Settings:
    # -----------------------------
    # DATABASE
    # -----------------------------
    DB_URL = os.getenv("DATABASE_URL")

    # -----------------------------
    # REDIS
    # -----------------------------
    REDIS_HOST = os.getenv("REDIS_HOST", "redis")
    REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))

    # -----------------------------
    # SECURITY
    # -----------------------------
    ADMIN_API_KEY = os.getenv("ADMIN_API_KEY")
    SECRET_KEY = os.getenv("SECRET_KEY")

    # -----------------------------
    # PAYMENTS
    # -----------------------------
    RAZORPAY_KEY_ID = os.getenv("RAZORPAY_KEY_ID")
    RAZORPAY_KEY_SECRET = os.getenv("RAZORPAY_KEY_SECRET")


settings = Settings()


