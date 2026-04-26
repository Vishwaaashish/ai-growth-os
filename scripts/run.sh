#!/bin/bash

cd "$(dirname "$0")/.."

echo "⚙️ Lightweight Restart Initiated..."

# -------------------------------
# PORT CLEANUP (SAFE)
# -------------------------------
echo "🧹 Checking port 8000..."

PID=$(lsof -ti:8000 2>/dev/null)

if [ ! -z "$PID" ]; then
  echo "⚠️ Killing process on port 8000 (PID: $PID)"
  kill -9 $PID 2>/dev/null || true
else
  echo "✅ Port 8000 already clean"
fi

# -------------------------------
# SERVICE VALIDATION
# -------------------------------
echo "🔍 Detecting services..."

SERVICES=$(docker compose config --services)

echo "📦 Available services:"
echo "$SERVICES"
echo ""

# -------------------------------
# TARGET SERVICES (EDIT IF NEEDED)
# -------------------------------
TARGET_SERVICES="api worker learning"

# Validate services exist
VALID_SERVICES=""

for svc in $TARGET_SERVICES; do
  if echo "$SERVICES" | grep -q "^$svc$"; then
    VALID_SERVICES="$VALID_SERVICES $svc"
  else
    echo "⚠️ Service '$svc' NOT FOUND in docker-compose"
  fi
done

if [ -z "$VALID_SERVICES" ]; then
  echo "❌ No valid services to restart. Exiting."
  exit 1
fi

echo ""
echo "🚀 Restarting services:$VALID_SERVICES"

# -------------------------------
# RESTART / START LOGIC
# -------------------------------
docker compose up -d $VALID_SERVICES

# -------------------------------
# STATUS CHECK
# -------------------------------
sleep 2

echo ""
echo "📊 Service Status:"
docker compose ps

echo ""
echo "✅ SYSTEM READY"
echo "🌐 API: http://localhost:8000/docs"

echo ""
echo "📄 Logs (if needed):"
echo "docker compose logs -f api"
echo "docker compose logs -f worker"
echo "docker compose logs -f learning"
