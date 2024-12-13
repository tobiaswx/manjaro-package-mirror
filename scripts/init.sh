#!/bin/bash

set -e
set -o pipefail

# Start monitoring (using correct Alpine path)
/usr/bin/node_exporter &

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