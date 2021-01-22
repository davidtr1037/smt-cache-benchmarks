#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

MAX_MEMORY=8000

FLAGS+="-libc=uclibc "
FLAGS+="-posix-runtime "
FLAGS+="-use-forked-solver=0 "
FLAGS+="-only-output-states-covering-new "
FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "
FLAGS+="-switch-type=internal "
#FLAGS+="-allow-external-sym-calls "
#FLAGS+="-all-external-warnings "

SEARCH="--search=dfs"

BC_FILE=${CURRENT_DIR}/build/make.bc
ARGS="--sym-files 1 1 -sym-stdin ${CURRENT_DIR}/make.input -r -n -R -f A"

ulimit -s unlimited
export KLEE_TEMPLATE=$(realpath ${CURRENT_DIR}/make.input)
