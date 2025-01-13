FROM docker.io/library/alpine:3.21.2

# Install required packages with pinned versions
RUN apk add --no-cache \
    bash=5.2.37-r0 \
    curl=8.11.1-r0 \
    logrotate=3.21.0-r1 \
    nginx=1.26.2-r3 \
    prometheus-node-exporter=1.8.2-r0 \
    rsync=3.3.0-r0 && \
    mkdir /srv/http

# Copy configuration files
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY scripts/* /scripts/
COPY config/logrotate.conf /etc/logrotate.d/manjaro-mirror

# Ensure scripts are executable
RUN chmod +x /scripts/*.sh

# Set up health check
HEALTHCHECK --interval=5m --timeout=3s \
  CMD ["curl", "-f", "http://localhost/health"]

EXPOSE 80 9100
VOLUME /srv/http/manjaro

ENV SOURCE_MIRROR=rsync://mirrorservice.org/repo.manjaro.org/repos/ \
    SLEEP=6h \
    RSYNC_BWLIMIT=0 \
    LOG_LEVEL=info

CMD ["/scripts/init.sh"]