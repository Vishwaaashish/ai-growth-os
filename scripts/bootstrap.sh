#!/bin/bash
set -e

cd "$(dirname "$0")/.."

# Kill port (safety)
PID=$(lsof -ti:8000 || true)
if [ ! -z "$PID" ]; then
  kill -9 $PID
fi

# Stop old containers
docker compose down > /dev/null 2>&1

# 🔨 BUILD (silent)
DOCKER_BUILDKIT=0 docker compose build > /dev/null 2>&1

# 🚀 START (VISIBLE — THIS GIVES YOUR REQUIRED OUTPUT)
docker compose up -d

sleep 3

echo ""
echo "✅ SYSTEM FULLY RUNNING"
echo "🌐 API: http://localhost:8000/docs"
echo "📊 Grafana: http://localhost:3000"
echo "📈 Prometheus: http://localhost:9090"
echo "⚙️ n8n: http://localhost:5678"

echo ""
echo "📄 Logs:"
echo "docker compose logs -f api"
echo "docker compose logs -f worker"
echo "docker compose logs -f learning"
