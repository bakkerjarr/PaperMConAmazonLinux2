#!/bin/bash
#title          : stop_papermc_server.sh
#description    : Stop a running PaperMC Docker container within a named screen
#                 session. Returns 0 if the container was stopped gracefully
#                 within a set number of retries. 1 is returned if the number
#                 of retries is exhausted.
#author         : Jarrod N. Bakker
#date           : 17-01-2022
#version        : 1.0.0
#usage          : stop_papermc_server.sh
#history        : 13-01-2022 - jnb - TO BE COMPLETED
#==============================================================================
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

log_fatal() {
    echo -e "`date '+%Y-%m-%d %H:%M:%S'` FATAL $1"
}

log_info() {
    echo -e "`date '+%Y-%m-%d %H:%M:%S'` INFO $1"
}
