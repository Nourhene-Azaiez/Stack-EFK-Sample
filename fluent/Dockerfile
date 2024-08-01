FROM fluent/fluentd:v1.17.0-debian-1.0

USER root

RUN apt-get update && apt-get install -y build-essential jq docker.io
RUN gem install elasticsearch -v 8.8.0
RUN gem install fluent-plugin-elasticsearch

COPY dockercmd.sh /usr/local/bin/dockercmd.sh
RUN chmod +x /usr/local/bin/dockercmd.sh

COPY conf/fluent.conf /fluentd/etc/
RUN fluentd -c /fluentd/etc/fluent.conf &