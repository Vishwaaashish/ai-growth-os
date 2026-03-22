#!/bin/bash

DATE=$(date +%F)

docker exec infrastructure-postgres pg_dumpall -U odoo > /home/$USER/infrastructure/backups/db-$DATE.sql
