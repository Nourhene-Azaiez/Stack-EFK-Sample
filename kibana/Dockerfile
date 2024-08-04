# Use the official Kibana image as a base
FROM bitnami/kibana:8.8.2

# Copy the import script and export file into the container
COPY import.sh /usr/share/kibana/import.sh
COPY export.ndjson /usr/share/kibana/export.ndjson

USER root
RUN chmod +x /usr/share/kibana/import.sh

# Run the import script when the container starts
CMD ["/usr/share/kibana/import.sh"]
