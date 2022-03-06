#!/bin/bash
#title          : stop_papermc_server.sh
#description    : Stop a running PaperMC Docker container within a named screen
#                 session. Returns:
#                   - 0: The container was stopped gracefully within a desired
#                        number of retries.
#                   - 1: The number of retries when checking the status of the
#                        started container has been exhausted.
#                   - 2: The provided name does not refer to a screen session
#                        that exists.
#                   - 3: The name for the container provided in argument 2 does
#                        not refer to a container that exists on the host.
#author         : Jarrod N. Bakker
#date           : 17-01-2022
#version        : 1.0.0
#usage          : stop_papermc_server.sh SCREEN_NAME CONTAINER_NAME
#history        : 06-03-2022 - jnb - Initial version complete.
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
if [ $cmd_res -ne 0 ]; then
    log_fatal "A screen session called '$SCREEN_NAME' does not exist! \
Exiting..."
    exit 2
fi

docker stats --no-stream "$CONTAINER" > /dev/null 2>&1
cmd_res=$?
if [ $cmd_res -ne 0 ]; then
    log_fatal "Docker container $CONTAINER does not exist! Exiting..."
    exit 3
fi

printf "`date '+%Y-%m-%d %H:%M:%S'` INFO Stopping container $CONTAINER in \
named screen session $SCREEN_NAME."
screen -S "$SCREEN_NAME" -X stuff "stop^M"

readonly MAX_RETRY=60
retry=0
CON_STATE=`docker ps -a --filter name="$CONTAINER" --format "{{.State}}"`
while [ "$CON_STATE" != "exited" ]; do
    printf "."
    if (( $retry >= $MAX_RETRY )); then
        printf "\n"
        docker kill "$CONTAINER"
        log_fatal "Container failed to be shutdown gracefully so it will be \
left alone. Exiting..."
        exit 1
    fi
    sleep 5s
    CON_STATE=`docker ps -a --filter name="$CONTAINER" --format "{{.State}}"`
    ((++retry))
done
echo " OK"
log_info "Container $CONTAINER has been shutdown gracefully."
