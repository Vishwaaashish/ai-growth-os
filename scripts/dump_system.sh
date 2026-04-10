#!/bin/bash

OUTPUT_DIR="system_dump_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo "🔷 Starting Full System Dump..."

# Project structure
tree -L 3 -a -I "__pycache__|.git|node_modules|venv" > "$OUTPUT_DIR/project_structure.txt" 2>/dev/null || find . -type f > "$OUTPUT_DIR/project_structure.txt"

# System info
uname -a > "$OUTPUT_DIR/system_info.txt"

# Processes
ps aux > "$OUTPUT_DIR/processes.txt"

# Disk usage
df -h > "$OUTPUT_DIR/disk_usage.txt"

# Memory
free -h > "$OUTPUT_DIR/memory.txt"

# Git state
git status > "$OUTPUT_DIR/git_status.txt"
git log --oneline -n 10 > "$OUTPUT_DIR/git_log.txt"

echo "✅ Dump Completed → $OUTPUT_DIR"
