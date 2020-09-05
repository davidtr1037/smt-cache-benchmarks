#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

BC_FILE=${CURRENT_DIR}/test_driver.bc

MAX_MEMORY=8000

FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-libc=uclibc "
FLAGS+="-posix-runtime "
FLAGS+="-use-forked-solver=0 "
FLAGS+="-only-output-states-covering-new "
FLAGS+="-simplify-sym-indices "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "

SEARCH="-search=dfs"
ARGS=10

function run_validation {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=1 \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        -collect-query-stats \
        -validate-caching \
        ${BC_FILE} ${ARGS}
}

function run_klee_qc_only {
    ${VANILLA_KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-cex-cache=0 \
        -use-branch-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_klee {
    ${VANILLA_KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-cex-cache=1 \
        -use-branch-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_cache_qc_only {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=0 \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_cache {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=1 \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${ARGS}
}

ulimit -s unlimited
