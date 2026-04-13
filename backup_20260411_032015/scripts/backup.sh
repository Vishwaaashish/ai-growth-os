#!/bin/bash

cd "$(dirname "$0")/.."

echo "🔷 Starting backup..."

BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Copy critical files
cp -r backend "$BACKUP_DIR/" 2>/dev/null
cp -r docs "$BACKUP_DIR/" 2>/dev/null
cp -r scripts "$BACKUP_DIR/" 2>/dev/null

# Copy configs if exist
[ -f .env.example ] && cp .env.example "$BACKUP_DIR/"
[ -f docker-compose.yml ] && cp docker-compose.yml "$BACKUP_DIR/"

echo "✅ Backup completed → $BACKUP_DIR"
