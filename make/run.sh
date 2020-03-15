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
FLAGS+="-allocate-determ-size=4000 "
FLAGS+="-switch-type=internal "
#FLAGS+="-allow-external-sym-calls "
#FLAGS+="-all-external-warnings "

SEARCH="--search=dfs"

BC_FILE=${CURRENT_DIR}/build/make.bc
ARGS="--sym-files 1 1 -sym-stdin ${CURRENT_DIR}/make.input -r -n -R -f A"

function run_stats {
    ${KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-global-id=1 \
        -collect-query-stats=1 \
        ${BC_FILE} ${ARGS}
}

function run_klee_qc_only {
    ${KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=0 \
        -cex-cache-try-all \
        -use-branch-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_klee {
    ${KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=1 \
        -cex-cache-try-all \
        -use-branch-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_cache_qc_only {
    ${KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=0 \
        -cex-cache-try-all \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_cache {
    ${KLEE} ${FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-cex-cache=1 \
        -cex-cache-try-all \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${ARGS}
}

ulimit -s unlimited

run_stats
run_klee_qc_only
run_cache_qc_only
run_klee
run_cache
