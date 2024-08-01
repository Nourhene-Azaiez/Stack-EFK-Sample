#!/bin/bash

# Fetch container details
containers=$(docker ps -a --format "{{json .}}")

# Fetch container stats
stats=$(docker stats -a --no-stream --format "{{json .}}")

# Convert container details to an associative array
declare -A container_map

# Read container details and map container IDs to their details
while read -r container; do
    container_id=$(echo "$container" | jq -r '.ID')
    container_map["$container_id"]="$container"
done <<< "$containers"

# Process stats and combine with container details
while read -r stat; do
    container_id=$(echo "$stat" | jq -r '.ID')

    # Extract stats
    cpu_usage=$(echo "$stat" | jq -r '.CPUPerc')
    mem_usage=$(echo "$stat" | jq -r '.MemUsage')
    mem_percent=$(echo "$stat" | jq -r '.MemPerc')
    net_io=$(echo "$stat" | jq -r '.NetIO')
    block_io=$(echo "$stat" | jq -r '.BlockIO')
    pids=$(echo "$stat" | jq -r '.PIDs')

    # Get corresponding container details
    container_info="${container_map[$container_id]}"

    # Extract the first word of the Status and handle empty Ports
    status=$(echo "$container_info" | jq -r '.Status' | awk '{print $1}')
    ports=$(echo "$container_info" | jq -r '.Ports')
    ports=${ports:-"none"}

    # Combine container details and stats into a single JSON object
    combined=$(jq -n \
        --arg id "$(echo "$container_info" | jq -r '.ID')" \
        --arg image "$(echo "$container_info" | jq -r '.Image')" \
        --arg command "$(echo "$container_info" | jq -r '.Command')" \
        --arg created_at "$(echo "$container_info" | jq -r '.CreatedAt')" \
        --arg status "$status" \
        --arg ports "$ports" \
        --arg names "$(echo "$container_info" | jq -r '.Names')" \
        --arg cpu "$cpu_usage" \
        --arg mem_usage "$mem_usage" \
        --arg mem_percent "$mem_percent" \
        --arg net_io "$net_io" \
        --arg block_io "$block_io" \
        --arg pids "$pids" \
        '{
            ID: $id,
            Image: $image,
            Command: $command,
            CreatedAt: $created_at,
            Status: $status,
            Ports: $ports,
            Names: $names,
            CPU_Percentage: $cpu,
            Mem_Usage_Limit: $mem_usage,
            Mem_Percentage: $mem_percent,
            Net_IO: $net_io,
            Block_IO: $block_io,
            PIDs: $pids
        }')

    # Print the JSON object
    echo "$combined"
done <<< "$stats"
