#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

MAX_MEMORY=8000

FLAGS+="-use-forked-solver=0 "
FLAGS+="-libc=uclibc "
FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-only-output-states-covering-new "

SEARCH="-search=dfs "

ARGS=15
BC_FILE=${CURRENT_DIR}/test_driver.bc

ulimit -s unlimited
