#!/bin/bash

set -e
set -o pipefail

echo "Starting nginx server."
nginx

while :
do
    bash /scripts/manjaro-mirror.sh
    sleep "${SLEEP}"
done

