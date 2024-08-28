#!/bin/bash

# Function to convert human-readable sizes to MiB and strip units
hr_to_mib_numeric() {
    local input=$1
    local value=$(echo $input | grep -oP '^\d+(\.\d+)?')
    local unit=$(echo $input | grep -oP '[A-Za-z]+')

    case $unit in
        B)
            # Convert bytes to MiB (1 MiB = 1024 * 1024 bytes)
            echo "scale=2; $value / 1024 / 1024" | bc
            ;;
        kB)
            # Convert kilobytes to MiB (1 MiB = 1024 kB)
            echo "scale=2; $value / 1024" | bc
            ;;
        KiB)
            # Convert kibibytes to MiB (1 MiB = 1024 KiB)
            echo "scale=2; $value / 1024" | bc
            ;;
        MB)
            # Convert megabytes to MiB (1 MiB = 1 MB * 1.048576)
            echo "scale=2; $value * 1.048576" | bc
            ;;
        GB)
            # Convert gigabytes to MiB (1 GB = 1024 MB = 1024 * 1024 MiB)
            echo "scale=2; $value * 1024 * 1.048576" | bc
            ;;
        MiB)
            # No conversion needed if already in MiB
            echo "$value"
            ;;
        GiB)
            # Convert gibibytes to MiB (1 GiB = 1024 MiB)
            echo "scale=2; $value * 1024" | bc
            ;;
        TiB)
            # Convert tebibytes to MiB (1 TiB = 1024 * 1024 MiB)
            echo "scale=2; $value * 1024 * 1024" | bc
            ;;
        kB)
            # Convert kilobytes to MiB (1 MiB = 1024 kB)
            echo "scale=2; $value / 1024" | bc
            ;;
        TB)
            # Convert terabytes to MiB (1 TB = 1024 GB = 1024 * 1024 MB = 1024 * 1024 * 1024 MiB)
            echo "scale=2; $value * 1024 * 1024" | bc
            ;;
        *)
            echo "Unsupported unit: $unit"
            return 1
            ;;
    esac
}

# Fetch container details
containers=$(docker ps -a --format "{{json .}}")

# Fetch container stats
stats=$(docker stats --no-stream --format "{{json .}}")

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
    cpu_usage=$(echo "$stat" | jq -r '.CPUPerc' | sed 's/%//')
    mem_usage=$(echo "$stat" | jq -r '.MemUsage')
    mem_percent=$(echo "$stat" | jq -r '.MemPerc' | sed 's/%//')
    net_io=$(echo "$stat" | jq -r '.NetIO')
    block_io=$(echo "$stat" | jq -r '.BlockIO')
    pids=$(echo "$stat" | jq -r '.PIDs')

    # Get corresponding container details
    container_info="${container_map[$container_id]}"

    # Extract the details from container_info
    image_name=$(echo "$container_info" | jq -r '.Image')
    command=$(echo "$container_info" | jq -r '.Command')
    created_at=$(echo "$container_info" | jq -r '.CreatedAt')
    status=$(echo "$container_info" | jq -r '.Status' | awk '{print $1}')
    ports=$(echo "$container_info" | jq -r '.Ports')
    names=$(echo "$container_info" | jq -r '.Names')

    # Convert MemUsage and MemLimit from human-readable to MiB
    mem_usage_value=$(hr_to_mib_numeric "$(echo "$mem_usage" | awk -F'/' '{print $1}')")
    mem_limit=$(hr_to_mib_numeric "$(echo "$mem_usage" | awk -F'/' '{print $2}')")

    # Split and convert NetIO into input and output in MiB
    net_input=$(hr_to_mib_numeric "$(echo "$net_io" | awk -F'/' '{print $1zz}')")
    net_output=$(hr_to_mib_numeric "$(echo "$net_io" | awk -F'/' '{print $2}')")

    # Split and convert BlockIO into input and output in MiB
    block_input=$(hr_to_mib_numeric "$(echo "$block_io" | awk -F'/' '{print $1}')")
    block_output=$(hr_to_mib_numeric "$(echo "$block_io" | awk -F'/' '{print $2}')")

    # Combine container details and stats into a single JSON object
    combined=$(jq -n \
        --arg id "$container_id" \
        --arg image "$image_name" \
        --arg command "$command" \
        --arg created_at "$created_at" \
        --arg status "$status" \
        --arg ports "$ports" \
        --arg names "$names" \
        --arg cpu "$cpu_usage" \
        --arg mem_usage_value "$mem_usage_value" \
        --arg mem_limit "$mem_limit" \
        --arg mem_percent "$mem_percent" \
        --arg net_input "$net_input" \
        --arg net_output "$net_output" \
        --arg block_input "$block_input" \
        --arg block_output "$block_output" \
        --arg pids "$pids" \
        '{
            ID: $id,
            Image: $image,
            Command: $command,
            CreatedAt: $created_at,
            Status: $status,
            Ports: $ports,
            Names: $names,
            CPU_Percentage: ($cpu | tonumber),
            Mem_Usage: ($mem_usage_value | tonumber),
            Mem_Limit: ($mem_limit | tonumber),
            Mem_Percentage: ($mem_percent | tonumber),
            Net_Input: ($net_input | tonumber),
            Net_Output: ($net_output | tonumber),
            Block_Input: ($block_input | tonumber),
            Block_Output: ($block_output | tonumber),
            PIDs: ($pids | tonumber)
        }')

    # Print the JSON object
    echo "$combined"
done <<< "$stats"