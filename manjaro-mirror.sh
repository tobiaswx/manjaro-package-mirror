#!/bin/bash

echo "$(date) >> Start synchronization with ${SOURCE_MIRROR}"

set -e
set -o pipefail

HOME="/srv/http"
TARGET="${HOME}/manjaro"
TMP="${HOME}/.tmp/manjaro"
LOCK="/tmp/rsync-manjaro.lock"
BWLIMIT="${RSYNC_BWLIMIT:-0}"  # Default to unlimited if not set
RSYNC_OPTS="${RSYNC_OPTS:-}"   # Additional rsync options

[ ! -d "${TARGET}" ] && mkdir -p "${TARGET}"
[ ! -d "${TMP}" ] && mkdir -p "${TMP}"

exec 9>"${LOCK}"
flock -n 9 || exit

if ! stty &>/dev/null; then
    QUIET="-q"
fi

# Log bandwidth limit if set
if [ "${BWLIMIT}" != "0" ]; then
    echo "$(date) >> Bandwidth limit set to ${BWLIMIT}KB/s"
fi

# Enhanced error handling and reporting
rsync_with_retry() {
    local attempts=3
    local attempt=1

    while [ $attempt -le $attempts ]; do
        if rsync -rtlvH --safe-links \
            --delete-after --progress \
            -h ${QUIET} --timeout=600 --contimeout=120 -p \
            --delay-updates --no-motd \
            --temp-dir="${TMP}" \
            --bwlimit="${BWLIMIT}" \
            ${RSYNC_OPTS} \
            "${SOURCE_MIRROR}" \
            "${TARGET}"; then
            return 0
        fi

        echo "$(date) >> Rsync attempt $attempt failed, waiting before retry..."
        sleep 30
        attempt=$((attempt + 1))
    done

    echo "$(date) >> All rsync attempts failed"
    return 1
}

if rsync_with_retry; then
    echo "$(date) >> Synchronization with ${SOURCE_MIRROR} completed successfully"
else
    echo "$(date) >> Synchronization failed after multiple attempts"
    exit 1
fi