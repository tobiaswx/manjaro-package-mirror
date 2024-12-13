FROM docker.io/library/alpine:3.19.1

# Install required packages
RUN apk add --no-cache \
    rsync \
    nginx \
    bash \
    prometheus-node-exporter \
    logrotate \
    curl && \
    mkdir /srv/http

# Copy configuration files
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY scripts/ /scripts/
COPY config/ /config/

# Set up log rotation
COPY logrotate.conf /etc/logrotate.d/manjaro-mirror

# Set up health check
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/health || exit 1

EXPOSE 80 9100
VOLUME /srv/http/manjaro

ENV SOURCE_MIRROR=rsync://mirrorservice.org/repo.manjaro.org/repos/ \
    SLEEP=6h \
    RSYNC_BWLIMIT=0 \
    LOG_LEVEL=info

CMD ["/scripts/init.sh"]