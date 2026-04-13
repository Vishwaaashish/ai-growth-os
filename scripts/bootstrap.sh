#!/bin/bash

echo "🔷 AI Growth OS Bootstrap Starting..."

# Move to project root
cd "$(dirname "$0")/.."

ROOT_DIR=$(pwd)
VENV_DIR="$ROOT_DIR/venv"
DEPS_FILE="$VENV_DIR/.deps_installed"

# -------------------------
# 1. START INFRA (DOCKER)
# -------------------------
echo "🐳 Starting infrastructure..."

cd infra
docker compose up -d
cd "$ROOT_DIR"

sleep 5

# -------------------------
# 2. SETUP VENV
# -------------------------
echo "📦 Setting up environment..."

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv venv
fi

source venv/bin/activate

# -------------------------
# 3. INSTALL DEPENDENCIES (ONCE)
# -------------------------
if [ ! -f "$DEPS_FILE" ]; then
    echo "📦 Installing dependencies..."
    pip install -r backend/requirements.txt
    touch "$DEPS_FILE"
else
    echo "✅ Dependencies already installed (skipping)"
fi

# -------------------------
# 4. SET PYTHON PATH (CRITICAL FIX)
# -------------------------
export PYTHONPATH="$ROOT_DIR/backend"

# -------------------------
# 5. START WORKER
# -------------------------
echo "⚙️ Starting worker..."

pkill -f "app.worker.worker" 2>/dev/null

nohup venv/bin/python -m app.worker.worker > worker.log 2>&1 &

sleep 2

echo "🧠 Starting Learning Processor..."

pkill -f learning_worker 2>/dev/null

nohup venv/bin/python -m app.core.learning.workers.learning_worker > learning.log 2>&1 &

sleep 2

# -------------------------
# 6. START API SERVER
# -------------------------
echo "🚀 Starting API..."

pkill -f uvicorn 2>/dev/null

nohup venv/bin/python -m uvicorn app.main:app \
    --host 0.0.0.0 \
    --port 8000 > server.log 2>&1 &

sleep 2

# -------------------------
# 7. STATUS OUTPUT
# -------------------------
echo ""
echo "✅ SYSTEM FULLY RUNNING"
echo "🌐 API: http://localhost:8000/docs"
echo "📊 Grafana: http://localhost:3000"
echo "📈 Prometheus: http://localhost:9090"
echo "⚙️ n8n: http://localhost:5678"
echo ""
echo "📄 Logs:"
echo "  tail -f server.log"
echo "  tail -f worker.log"
