#!/bin/bash

# 🔷 Move to backend
cd "$(dirname "$0")/../backend"

echo "🔴 Stopping old processes..."

pkill -f "uvicorn app.main:app"
pkill -f "rq worker"

sleep 2

echo "🧹 Cleaning port 8000..."

PID=$(lsof -ti:8000)
if [ ! -z "$PID" ]; then
  kill -9 $PID
fi

echo "⚙️ Activating environment..."

source venv/bin/activate

echo "🚀 Starting server..."

nohup uvicorn app.main:app --host 0.0.0.0 --port 8000 > ../server.log 2>&1 &

sleep 2

echo "🚀 Starting worker..."

nohup rq worker high default low dead > ../worker.log 2>&1 &

sleep 2

echo "✅ System running"

echo "📊 Logs:"
echo "tail -f server.log"
echo "tail -f worker.log"
