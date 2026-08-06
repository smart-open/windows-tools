#!/bin/bash
# I/O Monitor Script - Disk I/O performance monitoring and statistics
# Author: System Admin
# Usage: ./io_monitor.sh [-i interval] [-d device] [-t threshold]

VERSION="1.0"
INTERVAL=5
DEVICE=""
THRESHOLD=100
LOG_FILE="/var/log/io_monitor.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ALERT_COUNT=0

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

list_disks() {
    echo "=========================================="
    echo "Available Disk Devices"
    echo "=========================================="
    
    if command -v lsblk >/dev/null 2>&1; then
        lsblk -dpno NAME,SIZE,TYPE,MOUNTPOINT | grep "disk\|part"
    else
        df -h | grep "^/dev/" | awk '{print $1 " " $2 " " $6}'
    fi
}

get_disk_stats() {
    local dev="$1"
    grep " $dev " /proc/diskstats 2>/dev/null | head -1
}

calculate_io() {
    local dev="$1"
    local stats1=$(get_disk_stats "$dev")
    sleep $INTERVAL
    local stats2=$(get_disk_stats "$dev")
    
    local reads1=$(echo "$stats1" | awk '{print $4}')
    local writes1=$(echo "$stats1" | awk '{print $8}')
    local read_sectors1=$(echo "$stats1" | awk '{print $6}')
    local write_sectors1=$(echo "$stats1" | awk '{print $10}')
    
    local reads2=$(echo "$stats2" | awk '{print $4}')
    local writes2=$(echo "$stats2" | awk '{print $8}')
    local read_sectors2=$(echo "$stats2" | awk '{print $6}')
    local write_sectors2=$(echo "$stats2" | awk '{print $10}')
    
    local read_ops=$(( (reads2 - reads1) / INTERVAL ))
    local write_ops=$(( (writes2 - writes1) / INTERVAL ))
    local read_mb=$(echo "scale=2; ($read_sectors2 - $read_sectors1) * 512 / 1024 / 1024 / $INTERVAL" | bc 2>/dev/null || echo "0")
    local write_mb=$(echo "scale=2; ($write_sectors2 - $write_sectors1) * 512 / 1024 / 1024 / $INTERVAL" | bc 2>/dev/null || echo "0")
    
    echo "$read_ops $write_ops $read_mb $write_mb"
}

get_top_io_processes() {
    echo ""
    echo "Top I/O Processes:"
    
    if command -v iotop >/dev/null 2>&1; then
        iotop -botqqq -n 1 2>/dev/null | head -10
    elif command -v pidstat >/dev/null 2>&1; then
        pidstat -d 1 1 2>/dev/null | tail -15
    else
        ps -eo pid,comm,rchar,wchar --sort=-wchar | head -10
    fi
}

check_threshold() {
    local read_mb="$1"
    local write_mb="$2"
    local total=$(echo "$read_mb + $write_mb" | bc 2>/dev/null)
    
    local result=$(echo "$total > $THRESHOLD" | bc 2>/dev/null)
    if [ "$result" = "1" ]; then
        log "[ALERT] High I/O detected: ${total}MB/s (read: ${read_mb}MB/s, write: ${write_mb}MB/s)"
        ((ALERT_COUNT++))
    fi
}

monitor_single_disk() {
    local dev="$1"
    dev=$(basename "$dev")
    
    echo "=========================================="
    echo "Monitoring I/O for: /dev/$dev"
    echo "Interval: ${INTERVAL}s | Threshold: ${THRESHOLD}MB/s"
    echo "=========================================="
    printf "%-20s %10s %10s %12s %12s\n" "TIME" "READS/s" "WRITES/s" "READ MB/s" "WRITE MB/s"
    echo "=========================================="
    
    trap "echo ''; echo 'Stopped. Alerts: $ALERT_COUNT'; exit" SIGINT SIGTERM
    
    while true; do
        local result=$(calculate_io "$dev")
        local read_ops=$(echo "$result" | awk '{print $1}')
        local write_ops=$(echo "$result" | awk '{print $2}')
        local read_mb=$(echo "$result" | awk '{print $3}')
        local write_mb=$(echo "$result" | awk '{print $4}')
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        
        printf "%-20s %10s %10s %12s %12s\n" "$timestamp" "$read_ops" "$write_ops" "$read_mb" "$write_mb"
        
        check_threshold "$read_mb" "$write_mb"
    done
}

monitor_all_disks() {
    local disks=$(df | grep "^/dev/" | awk '{print $1}' | xargs -I{} basename {} | sort | uniq)
    
    echo "=========================================="
    echo "Monitoring All Disks - Summary"
    echo "Interval: ${INTERVAL}s"
    echo "=========================================="
    printf "%-20s" "TIME"
    for dev in $disks; do
        printf " %10s" "$dev"
    done
    echo ""
    printf "%-20s" ""
    for dev in $disks; do
        printf " %10s" "MB/s"
    done
    echo ""
    echo "=========================================="
    
    trap "echo ''; echo 'Stopped. Alerts: $ALERT_COUNT'; exit" SIGINT SIGTERM
    
    while true; do
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        printf "%-20s" "$timestamp"
        
        local total_io=0
        for dev in $disks; do
            local stats1=$(get_disk_stats "$dev")
            sleep 0.1
        done
        sleep $INTERVAL
        
        for dev in $disks; do
            local stats2=$(get_disk_stats "$dev")
            local sectors1=$(echo "$stats1" | awk '{print $6 + $10}')
            local sectors2=$(echo "$stats2" | awk '{print $6 + $10}')
            local mb=$(echo "scale=1; ($sectors2 - $sectors1) * 512 / 1024 / 1024 / $INTERVAL" | bc 2>/dev/null || echo "0")
            printf " %10s" "$mb"
        done
        echo ""
    done
}

generate_report() {
    echo "=========================================="
    echo "I/O Performance Report"
    echo "=========================================="
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    echo "--- Block Devices ---"
    if command -v lsblk >/dev/null 2>&1; then
        lsblk -o NAME,SIZE,ROTA,TYPE | grep disk
    else
        cat /proc/partitions 2>/dev/null
    fi
    
    echo ""
    echo "--- Mount Points ---"
    df -h | grep "^/dev/"
    
    echo ""
    echo "--- Current I/O Statistics ---"
    if command -v iostat >/dev/null 2>&1; then
        iostat -d -k 1 1 2>/dev/null | tail -20
    else
        echo "iostat not available, install sysstat package for detailed info"
        cat /proc/diskstats | head -10
    fi
}

while getopts "i:d:t:r:lh" opt; do
    case $opt in
        i) INTERVAL="$OPTARG" ;;
        d) DEVICE="$OPTARG" ;;
        t) THRESHOLD="$OPTARG" ;;
        r) RUNS="$OPTARG" ;;
        l) generate_report; exit 0 ;;
        h) echo "Usage: $0 [-i interval] [-d device] [-t threshold] [-l report]"; exit 0 ;;
    esac
done

echo "I/O Monitor Script v$VERSION"
echo ""

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${YELLOW}[WARNING]${NC} Running as non-root, some stats may be unavailable"
    echo ""
fi

if [ -n "$DEVICE" ]; then
    monitor_single_disk "$DEVICE"
else
    echo "No device specified, showing report..."
    generate_report
    echo ""
    echo "Use -d /dev/sdX to monitor a specific device"
fi