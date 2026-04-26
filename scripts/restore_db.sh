#!/bin/bash

set -a
source .env
set +a

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
  echo "❌ Usage: ./restore_db.sh <backup_file>"
  exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
  echo "❌ File not found: $BACKUP_FILE"
  exit 1
fi

echo "⚠️ Restoring database from $BACKUP_FILE"

docker exec -i postgres psql -U $POSTGRES_USER $POSTGRES_DB < $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "✅ Restore completed successfully"
else
  echo "❌ Restore failed"
  exit 1
fi
