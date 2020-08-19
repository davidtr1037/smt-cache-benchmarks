#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

MAX_MEMORY=8000

FLAGS=""
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

function run_validation {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=1 \
        -cex-cache-try-all \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        -collect-query-stats \
        -validate-caching \
        ${BC_FILE} ${ARGS}
}

function run_klee {
    ${VANILLA_KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-cex-cache=1 \
        -cex-cache-try-all \
        -use-branch-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_cache {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=1 \
        -cex-cache-try-all \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${ARGS}
}

ulimit -s unlimited
export KLEE_TEMPLATE=$(realpath ${CURRENT_DIR}/bash.input)
