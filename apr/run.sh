#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

MAX_MEMORY=8000

FLAGS=""
FLAGS+="-use-forked-solver=0 "
FLAGS+="-libc=uclibc "
FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-only-output-states-covering-new "

SEARCH="-search=dfs "

N=3
BC_FILE=${CURRENT_DIR}/test_driver.bc

function run_stats {
    ${KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-global-id=1 \
        -collect-query-stats=1 \
        ${BC_FILE} ${N}
}

function run_klee_qc_only {
    ${VANILLA_KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-cex-cache=0 \
        -cex-cache-try-all \
        -use-branch-cache=1 \
        ${BC_FILE} ${N}
}

function run_klee {
    ${VANILLA_KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-cex-cache=1 \
        -cex-cache-try-all \
        -use-branch-cache=1 \
        ${BC_FILE} ${N}
}

function run_cache_qc_only {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=0 \
        -cex-cache-try-all \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${N}
}

function run_cache {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=1 \
        -cex-cache-try-all \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${N}
}

ulimit -s unlimited

run_stats
run_klee_qc_only
run_cache_qc_only
run_klee
run_cache
