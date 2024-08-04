#!/bin/bash

# Start Kibana in the background
kibana --allow-root &

# Get the Kibana process ID
KIBANA_PID=$!

# Function to check Kibana availability
check_kibana() {
  curl -s http://localhost:5601 >/dev/null
}

# Wait for Kibana to be available
echo "Waiting for Kibana to be available..."
until check_kibana; do
  sleep 5
done

echo "Kibana is available. Waiting for migrations to complete..."

# Function to check if Kibana migration is complete
check_migration_complete() {
  curl -s curl -X GET "http://localhost:5601/api/status" -H "kbn-xsrf: true"

}

# Wait until migrations are complete
until check_migration_complete; do
  sleep 10
done

# Import saved objects using the Kibana API
curl -X POST "http://localhost:5601/api/saved_objects/_import" \
     -H "kbn-xsrf: true" \
     -F file=@/usr/share/kibana/export.ndjson

echo "Import completed."
wait