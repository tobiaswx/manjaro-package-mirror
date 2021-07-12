#!/bin/bash

echo "`date` >> Start synchronization with ${SOURCE_MIRROR}"

set -e
set -o pipefail

HOME="/srv/http"
TARGET="${HOME}/manjaro"
TMP="${HOME}/.tmp/manjaro"
LOCK="/tmp/rsync-manjaro.lock"

[ ! -d "${TARGET}" ] && mkdir -p "${TARGET}"
[ ! -d "${TMP}" ] && mkdir -p "${TMP}"

exec 9>"${LOCK}"
flock -n 9 || exit

if ! stty &>/dev/null; then
    QUIET="-q"
fi

rsync -rtlvH --safe-links \
    --delete-after --progress \
    -h ${QUIET} --timeout=600 --contimeout=120 -p \
    --delay-updates --no-motd \
    --temp-dir="${TMP}" \
    "${SOURCE_MIRROR}" \
    "${TARGET}"

echo "`date` >> Synchronization with ${SOURCE_MIRROR} completed"

