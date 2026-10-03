#!/bin/bash

# Define the target directory for reports and maximum retention days
LOG_DIR="./reports"
MAX_DAYS=7

# Get the current date in YYYY-MM-DD format
CURRENT_DATE=$(date +"%Y-%m-%d")

# Ensure the reports directory exists
mkdir -p "$LOG_DIR"

# Extract the latest alerts from the Wazuh manager container and save them into a date-named log file
docker exec -it single-node-wazuh.manager-1 tail -n 500  /var/ossec/logs/alerts/alerts.log > "$LOG_DIR/$CURRENT_DATE.log"

# Automatically find and remove log files older than the specified maximum days
find "$LOG_DIR" -type f -name "*.log" -mtime +$MAX_DAYS -exec rm -f {} \;

echo "[+] Report for date $CURRENT_DATE (!only last 500 logs) successfully saved. Log files older than $MAX_DAYS days have been cleaned up. To change number of writed logs redact this file /scripts/logrotate.sh"
