#!/bin/bash

cd "$(dirname "$0")/.."

echo "⚙️ Smart Clean Restart Initiated..."

# -------------------------------
# PORT CLEANUP
# -------------------------------
echo "🧹 Cleaning port 8000..."
PID=$(lsof -ti:8000 2>/dev/null)

if [ ! -z "$PID" ]; then
  echo "⚠️ Killing process on port 8000 (PID: $PID)"
  kill -9 $PID 2>/dev/null || true
else
  echo "✅ Port 8000 already clean"
fi

# -------------------------------
# TARGET SERVICES
# -------------------------------
TARGET_SERVICES="api worker learning"

echo "🔍 Validating services..."
SERVICES=$(docker compose config --services)

VALID_SERVICES=""
for svc in $TARGET_SERVICES; do
  if echo "$SERVICES" | grep -q "^$svc$"; then
    VALID_SERVICES="$VALID_SERVICES $svc"
  else
    echo "⚠️ Service '$svc' not found"
  fi
done

if [ -z "$VALID_SERVICES" ]; then
  echo "❌ No valid services found. Exiting."
  exit 1
fi

# -------------------------------
# FORCE REMOVE OLD CONTAINERS
# -------------------------------
echo ""
echo "🛑 Stopping old containers..."
docker compose stop $VALID_SERVICES

echo "🧹 Removing old containers..."
docker compose rm -f $VALID_SERVICES

# -------------------------------
# RESTART SERVICES CLEANLY
# -------------------------------
echo ""
echo "🚀 Starting fresh containers..."
docker compose up -d $VALID_SERVICES

# -------------------------------
# STATUS
# -------------------------------
sleep 2

echo ""
echo "📊 Service Status:"
docker compose ps

echo ""
echo "✅ CLEAN RESTART COMPLETE"
echo "🌐 API: http://localhost:8000/docs"
