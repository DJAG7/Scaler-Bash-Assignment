#!/bin/bash

# Function to check service status

check_service_status() {
    service_name=$1
    status=$(systemctl is-active $service_name 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "$service_name is running."
    else
        echo "$service_name is not running."
        return 1
    fi
}

# Function to get resources used by a certain service

get_resource_usage() {
    service_name=$1
    cpu_usage=$(ps -p $(pgrep -d',' -x $service_name) -o %cpu --no-headers | awk '{s+=$1} END {print s "%"}')
    memory_usage=$(ps -p $(pgrep -d',' -x $service_name) -o %mem --no-headers | awk '{s+=$1} END {print s "%"}')
    disk_usage=$(du -sh /var/lib/$service_name | awk '{print $1}')
    echo "CPU Usage: $cpu_usage"
    echo "Memory Usage: $memory_usage"
    echo "Disk Usage: $disk_usage"
}

# Main script

if [ $# -ne 1 ]; then
    echo "Usage: $0 <service_name>"
    exit 1
fi

service_name=$1
check_service_status $service_name
if [ $? -eq 0 ]; then
    get_resource_usage $service_name
fi
