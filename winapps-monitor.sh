#!/bin/bash
################################################################################
# WinApps Resource Monitor
# Shows CPU and RAM usage of the Windows VM Docker container
################################################################################

# Colors for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get container name
CONTAINER_NAME="WinApps"

# Check if container exists
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    yad --error \
        --title="WinApps Monitor" \
        --text="Windows VM container '${CONTAINER_NAME}' not found!\n\nPlease start the Windows VM first." \
        --width=400 \
        --button="OK:0"
    exit 1
fi

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    yad --warning \
        --title="WinApps Monitor" \
        --text="Windows VM is not currently running.\n\nContainer: ${CONTAINER_NAME}\nStatus: STOPPED" \
        --width=400 \
        --button="Start VM:0" \
        --button="Cancel:1"
    
    if [ $? -eq 0 ]; then
        # User clicked "Start VM"
        docker compose --file ~/.config/winapps/compose.yaml start
        notify-send "WinApps" "Starting Windows VM..." -i system-run
    fi
    exit 0
fi

# Get container stats (one-shot)
STATS=$(docker stats ${CONTAINER_NAME} --no-stream --format "{{.CPUPerc}}|{{.MemUsage}}|{{.MemPerc}}")

# Parse stats
CPU=$(echo "$STATS" | cut -d'|' -f1)
MEM_USAGE=$(echo "$STATS" | cut -d'|' -f2)
MEM_PERC=$(echo "$STATS" | cut -d'|' -f3)

# Get container uptime
UPTIME=$(docker inspect -f '{{.State.StartedAt}}' ${CONTAINER_NAME})
UPTIME_FORMATTED=$(date -d "$UPTIME" "+%Y-%m-%d %H:%M:%S")

# Create detailed view with yad
yad --info \
    --title="WinApps Resource Monitor" \
    --text="<b>Windows VM Resource Usage</b>\n\n<b>Container:</b> ${CONTAINER_NAME}\n<b>Status:</b> <span color='green'>RUNNING</span>\n<b>Started:</b> ${UPTIME_FORMATTED}\n\n<b>CPU Usage:</b> ${CPU}\n<b>Memory Usage:</b> ${MEM_USAGE} (${MEM_PERC})\n\n<i>Click 'Refresh' to update stats</i>" \
    --width=450 \
    --height=250 \
    --button="Refresh:bash -c '$0'" \
    --button="Open VNC:xdg-open http://127.0.0.1:8006" \
    --button="Close:0"
