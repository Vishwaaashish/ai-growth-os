#!/bin/bash

# Create backup directory
mkdir -p /home/aashish/backup/db

# Date variable
DATE=$(date +%F)

# Database backup
/usr/bin/docker exec -t infrastructure-postgres pg_dump -U odoo ai_system > /home/aashish/backup/db/ai_system_$DATE.sql

# Delete backups older than 7 days
find /home/aashish/backup/db -type f -mtime +7 -delete
