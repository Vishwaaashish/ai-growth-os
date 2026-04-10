import time
import requests
from redis_client import r

WEBHOOK_URL = "http://localhost:5678/webhook-test/lead"

print("🚀 Worker started...")

while True:
    lead = r.rpop("lead_queue")

    if lead:
        print("🔥 Processing Lead:", lead)

        name, email, phone, business = lead.split("|")

        data = {
            "name": name,
            "email": email,
            "phone": phone,
            "business": business
        }

        try:
            response = requests.post(WEBHOOK_URL, json=data)
            print("✅ Sent to n8n:", response.status_code)
        except Exception as e:
            print("❌ Error:", e)

    time.sleep(2)
