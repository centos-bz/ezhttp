#!/bin/bash

log(){
    local level=$1
    local msg=$2
    local dateName=`date +%Y-%m-%d" "%H:%M:%S`
    [[ ! -d "${LOG_DIR}/" ]] && mkdir -p $LOG_DIR
    echo "[${dateName}] [${level}] ${msg}" >> $LOG_PATH
}

check_var_null(){
    local var=$1
    local val=""
    eval val=\$$var
    if [[ -z "$val" ]]; then
        log ERROR "$var is null."
        return 1
    else
        return 0
    fi 
}