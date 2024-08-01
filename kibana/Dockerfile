FROM bitnami/kibana:8.8.2

USER root

COPY kibana.yml /opt/bitnami/kibana/config/kibana.yml

COPY export.ndjson /usr/share/kibana/export.ndjson
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

# Use ENTRYPOINT to handle starting Kibana and running the import script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
