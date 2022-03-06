#!/bin/bash
#title          : start_papermc_server.sh
#description    : Start a stopped PaperMC Docker container within a named
#                 screen session. Returns:
#                   - 0: The container is detected in being in a 'running'
#                        state within a set number of retries.
#                   - 1: The number of retries when checking the status of the
#                        started container has been exhausted.
#                   - 2: The provided name for the new screen session is
#                        already being used. Note that screen can handle this
#                        but this script does not want to.
#                   - 3: The name for the container provided in argument 2 does
#                        not refer to a container that exists on the host.
#author         : Jarrod N. Bakker
#date           : 13-01-2022
#version        : 1.0.0
#usage          : start_papermc_server.sh SCREEN_NAME CONTAINER_NAME
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

readonly SCREEN_NAME="$1"
readonly CONTAINER="$2"

screen -ls "$SCREEN_NAME" | grep -w "$SCREEN_NAME" > /dev/null 2>&1
cmd_res=$?
if [ $cmd_res -eq 0 ]; then
    log_fatal "A screen session called '$SCREEN_NAME' already exists! \
Exiting..."
    exit 2
fi

docker stats --no-stream "$CONTAINER" > /dev/null 2>&1
cmd_res=$?
if [ $cmd_res -ne 0 ]; then
    log_fatal "Docker container $CONTAINER does not exist! Exiting..."
    exit 3
fi

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
