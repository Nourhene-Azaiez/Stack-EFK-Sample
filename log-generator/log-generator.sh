#!/bin/bash

# Function to generate a random integer
random_int() {
  echo $((RANDOM % 1000))
}

# Function to generate a random string
random_string() {
  tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 10
}

# Function to generate a random logger class name
random_logger_class_name() {
  local classNames=("org.jboss.logging.DelegatingBasicLogger" "io.quarkus.logging.Log")
  echo ${classNames[$RANDOM % ${#classNames[@]}]}
}

# Function to generate a random logger name
random_logger_name() {
  local loggerNames=("io.undertow.request.io" "io.quarkus.http.io" "io.vertx.core.impl.BlockedThreadChecker")
  echo ${loggerNames[$RANDOM % ${#loggerNames[@]}]}
}

# Function to generate a random level
random_level() {
  local levels=("DEBUG" "INFO" "WARN" "ERROR" "FATAL")
  echo ${levels[$RANDOM % ${#levels[@]}]}
}

# Function to generate a random log message
random_message() {
  local messages=("Exception handling request" "Error processing request" "Unexpected error occurred" "Unhandled exception")
  echo "${messages[$RANDOM % ${#messages[@]}]} $(random_string)"
}

# Function to generate a random process name
random_process_name() {
  local processNames=("NativeImageGeneratorRunner\$JDK9Plus" "MainProcessRunner" "BackgroundJobHandler")
  echo ${processNames[$RANDOM % ${#processNames[@]}]}
}

# Function to generate a random MDC object
random_mdc() {
  jq -n \
    --arg spanId "$(random_string)" \
    --arg parentId "$(random_int)" \
    --arg cuid "$(random_string)" \
    --arg traceId "$(random_string)" \
    --arg uriBase "http://$(random_string).com/api/v2/" \
    --arg sampled "$(random_int)" \
    --arg uriPath "/$(random_string)" \
    --arg uriMethod "$(random_string)" \
    '{
      spanId: $spanId,
      parentId: $parentId,
      cuid: $cuid,
      traceId: $traceId,
      uriBase: $uriBase,
      sampled: $sampled,
      uriPath: $uriPath,
      uriMethod: $uriMethod
    }'
}

generate_stack_trace() {
  local level=$1
  local num_lines=$((RANDOM % 20 + 10))  # Random number of lines between 10 and 30
  local trace=""

  if [ "$level" == "ERROR" ]; then
    for ((i = 0; i < num_lines; i++)); do
      local class_name="ClassName$(random_int)"
      local method_name="method$(random_int)"
      local line_number=$((RANDOM % 100 + 1))  # Line number between 1 and 100

      trace+="$class_name.$method_name($class_name.java:$line_number)\n"
    done
  fi

  echo -e "$trace"
}

while true; do
# Current timestamp in ISO 8601 format
  timestamp=$(date -Iseconds)

# Generate JSON object
  json=$(jq -n \
    --arg timestamp "$timestamp" \
    --arg sequence "$(random_int)" \
    --arg loggerClassName "$(random_logger_class_name)" \
    --arg loggerName "$(random_logger_name)" \
    --arg level "$(random_level)" \
    --arg message "$(random_message)" \
    --arg threadName "executor-thread-$(random_int)" \
    --arg threadId "$(random_int)" \
    --arg mdc "$(random_mdc)" \
    --arg ndc "$(random_string)" \
    --arg hostName "$(random_string)" \
    --arg processName "$(random_process_name)" \
    --arg processId "$(random_int)" \
    --arg stackTrace "$(generate_stack_trace "$log_level")" \
    '{
      timestamp: $timestamp,
      sequence: ($sequence | tonumber),
      loggerClassName: $loggerClassName,
      loggerName: $loggerName,
      level: $level,
      message: $message,
      threadName: $threadName,
      threadId: ($threadId | tonumber),
      mdc: ($mdc | fromjson),
      ndc: $ndc,
      hostName: $hostName,
      processName: $processName,
      processId: ($processId | tonumber),
      stackTrace: $stackTrace
    }')

    echo $json
    sleep $((RANDOM % 60))
done
