FROM docker.io/library/alpine:3

# Install required packages with pinned versions
RUN apk add --no-cache \
    bash \
    curl \
    logrotate \
    nginx \
    prometheus-node-exporter \
    rsync && \
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