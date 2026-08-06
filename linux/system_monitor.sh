#!/bin/bash
# System Monitor Script - Real-time monitoring with alerts
# Author: System Admin
# Usage: ./system_monitor.sh [-i interval] [-a alert]

VERSION="1.0"
INTERVAL=5
ALERT_THRESHOLD=80
ALERT_EMAIL=""
LOG_FILE="/var/log/system_monitor.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

alert() {
    local msg="$1"
    log "[ALERT] $msg"
    if [ -n "$ALERT_EMAIL" ]; then
        echo "$msg" | mail -s "System Alert: $msg" "$ALERT_EMAIL"
    fi
}

get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1
}

get_mem_usage() {
    free | awk '/Mem:/ {print int($3/$2 * 100)}'
}

get_disk_usage() {
    df -h / | awk '/\// {print $5}' | tr -d '%'
}

get_swap_usage() {
    free | awk '/Swap:/ {print int($3/$2 * 100)}'
}

get_load_avg() {
    cat /proc/loadavg | awk '{print $1, $2, $3}'
}

get_top_processes() {
    ps aux --sort=-%cpu | head -6 | tail -5
}

check_alerts() {
    local cpu=$(get_cpu_usage)
    local mem=$(get_mem_usage)
    local disk=$(get_disk_usage)
    
    [ "$cpu" -gt "$ALERT_THRESHOLD" ] && alert "High CPU usage: ${cpu}%"
    [ "$mem" -gt "$ALERT_THRESHOLD" ] && alert "High Memory usage: ${mem}%"
    [ "$disk" -gt "$ALERT_THRESHOLD" ] && alert "High Disk usage: ${disk}%"
}

show_dashboard() {
    clear
    echo "=================================================="
    echo "       System Monitor v$VERSION"
    echo "=================================================="
    echo "Interval: ${INTERVAL}s | Alert: ${ALERT_THRESHOLD}%"
    echo "=================================================="
    echo ""
    
    local cpu=$(get_cpu_usage)
    local mem=$(get_mem_usage)
    local disk=$(get_disk_usage)
    local swap=$(get_swap_usage)
    local load=$(get_load_avg)
    
    echo "--- CPU Usage ---"
    [ "$cpu" -ge "$ALERT_THRESHOLD" ] && echo -e "CPU: ${RED}${cpu}%${NC}" || echo -e "CPU: ${GREEN}${cpu}%${NC}"
    
    echo ""
    echo "--- Memory Usage ---"
    [ "$mem" -ge "$ALERT_THRESHOLD" ] && echo -e "RAM: ${RED}${mem}%${NC}" || echo -e "RAM: ${GREEN}${mem}%${NC}"
    [ "$swap" -ge "$ALERT_THRESHOLD" ] && echo -e "Swap: ${RED}${swap}%${NC}" || echo -e "Swap: ${GREEN}${swap}%${NC}"
    
    echo ""
    echo "--- Disk Usage (/) ---"
    [ "$disk" -ge "$ALERT_THRESHOLD" ] && echo -e "Disk: ${RED}${disk}%${NC}" || echo -e "Disk: ${GREEN}${disk}%${NC}"
    
    echo ""
    echo "--- Load Average ---"
    echo "1min: $(echo $load | awk '{print $1}') | 5min: $(echo $load | awk '{print $2}') | 15min: $(echo $load | awk '{print $3}')"
    
    echo ""
    echo "--- Top 5 CPU Processes ---"
    get_top_processes
    
    echo ""
    echo "=================================================="
    echo "Press Ctrl+C to exit"
}

while getopts "i:a:h" opt; do
    case $opt in
        i) INTERVAL="$OPTARG" ;;
        a) ALERT_THRESHOLD="$OPTARG" ;;
        h) echo "Usage: $0 [-i interval] [-a alert_threshold]"; exit 0 ;;
    esac
done

echo "Starting System Monitor..."
log "System Monitor started - interval: ${INTERVAL}s, threshold: ${ALERT_THRESHOLD}%"

trap "echo 'Exiting...'; log 'System Monitor stopped'; exit" SIGINT SIGTERM

while true; do
    show_dashboard
    check_alerts
    sleep "$INTERVAL"
done