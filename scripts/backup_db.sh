#!/bin/bash

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."

# Load env
if [ -f "$PROJECT_ROOT/.env" ]; then
  source "$PROJECT_ROOT/.env"
else
  echo "❌ .env file not found"
  exit 1
fi

# Timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$PROJECT_ROOT/backups"
mkdir -p "$BACKUP_DIR"

echo "🔄 Starting backup at $TIMESTAMP"

# Get container name dynamically
POSTGRES_CONTAINER=$(docker ps --filter "name=postgres" --format "{{.Names}}" | head -n 1)

if [ -z "$POSTGRES_CONTAINER" ]; then
  echo "❌ PostgreSQL container not found"
  exit 1
fi

# Run backup
docker exec -t $POSTGRES_CONTAINER pg_dump -U $POSTGRES_USER $POSTGRES_DB > "$BACKUP_DIR/backup_$TIMESTAMP.sql"

if [ $? -eq 0 ]; then
  echo "✅ Backup completed: backup_$TIMESTAMP.sql"
else
  echo "❌ Backup failed"
fi
