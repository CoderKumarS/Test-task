#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to cron.php (in the same directory)
PHP_SCRIPT="$SCRIPT_DIR/cron.php"

# Find PHP executable
PHP_BIN=$(which php)
if [ -z "$PHP_BIN" ]; then
    echo "PHP is not installed or not found in PATH."
    exit 1
fi

# Run cron.php immediately
"$PHP_BIN" "$PHP_SCRIPT"

# Add a cron job to run cron.php every minute
CRON_JOB="* * * * * $PHP_BIN $PHP_SCRIPT"

# Check if the cron job already exists
crontab -l 2>/dev/null | grep -F "$CRON_JOB" >/dev/null
if [ $? -ne 0 ]; then
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cron job added."
else
    echo "Cron job already exists."
fi