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

SEARCH="-search=dfs "

ARGS="A --sym-files 1 100"
BC_FILE=${CURRENT_DIR}/build/bash.bc

ulimit -s unlimited
export KLEE_TEMPLATE=$(realpath ${CURRENT_DIR}/bash.input)
