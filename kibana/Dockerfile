FROM bitnami/kibana:8.8.2

USER root

COPY kibana.yml /opt/bitnami/kibana/config/kibana.yml

COPY export.ndjson /usr/share/kibana/export.ndjson
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN apt-get update && \
    apt-get install -y nginx

COPY web/front /usr/share/nginx/front
COPY web/nginx.conf /etc/nginx/nginx.conf
RUN kibana-keystore create

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
