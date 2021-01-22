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
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "

SEARCH="-search=dfs "

BC_FILE=${CURRENT_DIR}/build/test_driver.bc
ARGS=15

function run_merge {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-rebase=1 \
        -use-recursive-rebase=1 \
        -reuse-segments \
        -use-cex-cache=0 \
        -use-branch-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_merge_cache {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -use-sym-addr \
        -use-rebase=1 \
        -use-recursive-rebase=1 \
        -use-cex-cache=0 \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${ARGS}
}

ulimit -s unlimited
