#!/bin/bash

# Start Kibana in the background

#Change the kibana password here in case it did not work in docker compose 
while ! curl -s -u elastic:elastic http://elasticsearch:9200/_cluster/health > /dev/null; do 
        sleep 5s; 
done;
      # Check the current users and authentication status
curl -X GET http://elasticsearch:9200/_security/_authenticate -u elastic:elastic;

curl -X POST http://elasticsearch:9200/_security/user/kibana_system/_password \
          -H 'Content-Type: application/json' \
          -u elastic:elastic \
          -d '{"password":"kibanapass"}';


kibana --allow-root &

# Get the Kibana process ID
KIBANA_PID=$!

# Set Kibana username and password
KIBANA_USERNAME="elastic"
KIBANA_PASSWORD="elastic"  # Replace with your actual password

# Function to check Kibana availability
check_kibana() {
  curl -u "$KIBANA_USERNAME:$KIBANA_PASSWORD" -s http://localhost:5601 >/dev/null 2>&1
}

# Wait for Kibana to be available
until check_kibana; do
  sleep 5
done

# Function to check if Kibana migration is complete
check_migration_complete() {
  curl -u "$KIBANA_USERNAME:$KIBANA_PASSWORD" -s -X GET "http://localhost:5601/api/status" -H "kbn-xsrf: true" >/dev/null 2>&1
}

# Wait until migrations are complete
until check_migration_complete; do
  sleep 5
done

sleep 20

# Import saved objects using the Kibana API
curl -u "$KIBANA_USERNAME:$KIBANA_PASSWORD" -X POST "http://localhost:5601/api/saved_objects/_import" \
     -H "kbn-xsrf: true" \
     -F file=@/usr/share/kibana/export.ndjson >/dev/null 2>&1


curl -X POST "elasticsearch:9200/_security/user/REFCONTACT" -H 'Content-Type: application/json' -u elastic:elastic -d'
{
  "password": "REFCONTACT",
  "roles": ["viewer"],
  "full_name": "REFCONTACT_user_group",
  "email": "nourhene.azaiez@sofrecom.com"
}'

# Start Nginx
service nginx start &

# Create the Kibana keystore if it doesn't exist
yes| kibana-keystore create
# Generate and store encryption keys
kibana-encryption-keys generate | kibana-keystore add xpack.encryptedSavedObjects.encryptionKey --stdin
kibana-encryption-keys generate| kibana-keystore add xpack.security.encryptionKey --stdin
kibana-encryption-keys generate| kibana-keystore add xpack.reporting.encryptionKey --stdin

wait
