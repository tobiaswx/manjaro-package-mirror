#!/bin/bash

set -e
set -o pipefail

# Start monitoring
/usr/sbin/node_exporter &

# Start nginx with health endpoint
nginx

# Start log rotation daemon
crond

# Main sync loop
while :
do
    bash /scripts/manjaro-mirror.sh
    sleep "${SLEEP}"
done