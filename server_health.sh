#!/bin/bash

# Linux Server Health Monitor

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

echo "================================"
echo "       SERVER HEALTH REPORT"
echo "================================"

# Check CPU usage
check_cpu() {
    CPU_USAGE=$(top -bn1 | awk -F',' '/Cpu\(s\)/ {
        for (i=1; i<=NF; i++) {
            if ($i ~ /id/) {
                gsub(/[^0-9.]/, "", $i)
                print 100 - $i
                exit
            }
        }
    }')

    if [[ -z "$CPU_USAGE" ]]; then
        echo "CPU: Unable to read usage"
        return 1
    fi

    CPU_USAGE=${CPU_USAGE%.*}
    echo "CPU Usage: ${CPU_USAGE}%"

    if (( CPU_USAGE > CPU_THRESHOLD )); then
        echo "WARNING: High CPU usage!"
    else
        echo "CPU status: Normal"
    fi
}

# Check memory usage
check_memory() {
    MEMORY_USAGE=$(free | awk '/Mem:/ {
        if ($2 > 0) print int(($3/$2)*100)
    }')

    if [[ -z "$MEMORY_USAGE" ]]; then
        echo "Memory: Unable to read usage"
        return 1
    fi

    echo "Memory Usage: ${MEMORY_USAGE}%"

    if (( MEMORY_USAGE > MEMORY_THRESHOLD )); then
        echo "WARNING: High memory usage!"
    else
        echo "Memory status: Normal"
    fi
}

# Check disk usage
check_disk() {
    DISK_USAGE=$(df -P / | awk 'NR==2 {
        gsub("%", "", $5)
        print $5
    }')

    echo "Disk Usage: ${DISK_USAGE}%"

    if (( DISK_USAGE > DISK_THRESHOLD )); then
        echo "WARNING: High disk usage!"
    else
        echo "Disk status: Normal"
    fi
}

echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"
echo "Date: $(date)"
echo "--------------------------------"

check_cpu
check_memory
check_disk

echo "================================"
echo "       REPORT COMPLETED"
echo "================================"
