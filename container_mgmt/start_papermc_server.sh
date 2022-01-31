#!/bin/bash
#title          : start_papermc_server.sh
#description    : Start a stopped PaperMC Docker container within a named
#                 screen session. Returns 0 if the container is detected in
#                 being in a 'running' state within a set number of retries. 1
#                 is returned if the number of retries is exhausted.
#author         : Jarrod N. Bakker
#date           : 13-01-2022
#version        : 1.0.0
#usage          : start_papermc_server.sh
#history        : 13-01-2022 - jnb - Initial version complete.
#==============================================================================
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

log_fatal() {
    echo -e "`date '+%Y-%m-%d %H:%M:%S'` FATAL $1"
}

log_info() {
    echo -e "`date '+%Y-%m-%d %H:%M:%S'` INFO $1"
}

readonly SCREEN_NAME="papermc"
readonly CONTAINER="papermc-1.18.1-140-1"

printf "`date '+%Y-%m-%d %H:%M:%S'` INFO Starting container $CONTAINER in \
named screen session $SCREEN_NAME."
screen -dAmS "$SCREEN_NAME" docker start -ai "$CONTAINER"

readonly MAX_RETRY=5
retry=0
CON_STATE=`docker ps -a --filter name="$CONTAINER" --format "{{.State}}"`
while [ "$CON_STATE" != "running" ]; do
    printf "."
    if (( $retry >= $MAX_RETRY )); then
        printf "\n"
        docker kill "$CONTAINER"
        log_fatal "Container failed to start. Exiting..."
        exit 1
    fi
    sleep 5s
    CON_STATE=`docker ps -a --filter name="$CONTAINER" --format "{{.State}}"`
    ((++retry))
done
echo " OK"
log_info "Container $CONTAINER is now running."
