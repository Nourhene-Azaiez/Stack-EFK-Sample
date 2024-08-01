#!/bin/bash

generate_random_message() {
  local messages=(
    "Starting application"
    "Listening on port 8000"
    "Booting worker"
    "Shutting down"
    "Error occurred while processing"
    "Connection established"
    "Task completed successfully"
    "Warning: Low memory"
    "Debug: Configuration loaded"
    "Info: User logged in"
  )
  local index=$((RANDOM % ${#messages[@]}))
  echo "${messages[$index]}"
}

generate_log() {
  local levels=("INFO" "ERROR" "WARN")
  local pid=$((RANDOM % 20 + 1))
  local timestamp=$(date -u +"%Y-%m-%d %H:%M:%S +0000")
  local level_index=$((RANDOM % ${#levels[@]}))

  # Directly output the log message
  local message=$(generate_random_message)
  echo "[$timestamp] [$pid] [${levels[$level_index]}] $message"
}

generate_logs() {
  while true; do
    generate_log
    sleep $((RANDOM % 2 + 1))
  done
}

generate_logs
