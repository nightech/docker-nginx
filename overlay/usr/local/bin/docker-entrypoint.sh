#!/usr/bin/env bash

set -e

# Ini
declare -A ENV_CONFIG=()
ENV_CONFIG[WORKER_PROCESSES]=${WORKER_PROCESSES:-"1"}
ENV_CONFIG[WORKER_CONNECTIONS]=${WORKER_CONNECTIONS:-"1024"}
ENV_CONFIG[CLIENT_MAX_BODY_SIZE]=${CLIENT_MAX_BODY_SIZE:-"8m"}

for FILE in `find  /etc/nginx/ -type f -name *.conf`;  do
    if [ -w "$FILE" ]
    then
        for KEY in "${!ENV_CONFIG[@]}"; do
            sed -i.bak "s!\%"$KEY"\%!"${ENV_CONFIG[$KEY]}"!g" $FILE
        done
    fi
done

find  /etc/nginx -type f -name *.bak -delete

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- nginx "$@"
fi

exec "$@"
