#!/bin/bash

cd "$(dirname "$0")/.."

OUTPUT_DIR="system_dump_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo "🔷 Starting system dump..."

# Structure
tree -L 3 -a -I "__pycache__|.git|venv" > "$OUTPUT_DIR/project_structure.txt" 2>/dev/null || find . -type f > "$OUTPUT_DIR/project_structure.txt"

# System info
uname -a > "$OUTPUT_DIR/system_info.txt"

# Processes
ps aux > "$OUTPUT_DIR/processes.txt"

# Git state
git status > "$OUTPUT_DIR/git_status.txt"
git log --oneline -n 10 > "$OUTPUT_DIR/git_log.txt"

# Python env
which python > "$OUTPUT_DIR/python_path.txt"

echo "✅ Dump completed → $OUTPUT_DIR"
