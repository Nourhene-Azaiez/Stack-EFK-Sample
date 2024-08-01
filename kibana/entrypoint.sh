#!/bin/bash

# Start Kibana in the background
/opt/bitnami/kibana/bin/kibana --allow-root &

# Wait for Kibana to be up and running
echo "Waiting for Kibana to start..."
until curl -X GET "http://localhost:5601/api/status" -H "kbn-xsrf: true" >/dev/null 2>&1; do
    sleep 10
done
sleep 20
# echo "Kibana is available. Checking readiness..."

# # Wait for Kibana to be fully ready (optional, to handle Kibana setup phase)
# until curl -X GET "http://localhost:5601/api/status" -H "kbn-xsrf: true" | grep '"status": "green"' >/dev/null 2>&1; do
#     echo "Kibana is not fully ready, waiting..."
#  
# done

# Upload the data
file_path="/usr/share/kibana/export.ndjson"
response=$(curl -s -X POST "http://localhost:5601/api/saved_objects/_import" \
                  -H "kbn-xsrf: true" \
                  -H "Content-Type: multipart/form-data" \
                  -F "file=@$file_path")

# Keep the container running
wait
