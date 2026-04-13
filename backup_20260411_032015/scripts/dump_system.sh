#!/bin/bash

cd "$(dirname "$0")/.."

OUTPUT_DIR="system_dump_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo "Starting system dump..."

# project structure
tree -L 3 -a -I "__pycache__|.git|venv" > "$OUTPUT_DIR/project_structure.txt" 2>/dev/null || find . -type f > "$OUTPUT_DIR/project_structure.txt"

# system info
uname -a > "$OUTPUT_DIR/system_info.txt"

# processes
ps aux > "$OUTPUT_DIR/processes.txt"

# git state
git status > "$OUTPUT_DIR/git_status.txt"

echo "Dump completed → $OUTPUT_DIR"
