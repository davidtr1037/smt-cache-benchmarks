#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

MAX_MEMORY=8000

FLAGS+="-libc=uclibc "
FLAGS+="-posix-runtime "
FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-use-forked-solver=0 "
FLAGS+="-only-output-states-covering-new "
FLAGS+="-switch-type=internal "
FLAGS+="-simplify-sym-indices "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "

SEARCH="--search=dfs "

BC_FILE=${CURRENT_DIR}/build/src/m4.bc
ARGS="-sym-stdin ${CURRENT_DIR}/m4.input -H37 -G"

ulimit -s unlimited
