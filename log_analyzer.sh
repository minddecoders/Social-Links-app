#!/bin/bash

# Application Log Analyzer

LOG_FILE="$1"

if [[ -z "$LOG_FILE" ]]; then
    echo "Usage: ./log_analyzer.sh <log_file>"
    exit 1
fi

if [[ ! -f "$LOG_FILE" ]]; then
    echo "ERROR: Log file not found: $LOG_FILE"
    exit 1
fi

echo "================================"
echo "       LOG ANALYSIS REPORT"
echo "================================"

echo "Log File: $LOG_FILE"
echo "Total Lines: $(wc -l < "$LOG_FILE")"

echo "--------------------------------"
echo "ERROR COUNT"

ERROR_COUNT=$(grep -ic "error" "$LOG_FILE" || true)
echo "Total Errors: $ERROR_COUNT"

echo "--------------------------------"
echo "WARNING COUNT"

WARNING_COUNT=$(grep -ic "warning" "$LOG_FILE" || true)
echo "Total Warnings: $WARNING_COUNT"

echo "--------------------------------"
echo "INFO COUNT"

INFO_COUNT=$(grep -ic "info" "$LOG_FILE" || true)
echo "Total Info Messages: $INFO_COUNT"

echo "--------------------------------"
echo "LATEST 5 ERRORS"

grep -i "error" "$LOG_FILE" | tail -n 5 || true

echo "--------------------------------"
echo "TOP 5 IP ADDRESSES"

awk '{
    for (i=1; i<=NF; i++) {
        if ($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) {
            print $i
        }
    }
}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5

echo "================================"
echo "       ANALYSIS COMPLETED"
echo "================================"

