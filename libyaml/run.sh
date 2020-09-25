#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

BC_FILE=${CURRENT_DIR}/test_driver.bc
MAX_TIME=3600
MAX_TIME_INCREASED=5400
MAX_INST=18627209
MAX_MEMORY=8000
SIZE=10

FLAGS=""
FLAGS+="-max-memory=8000 "
FLAGS+="-libc=uclibc "
FLAGS+="-search=dfs "
FLAGS+="-use-forked-solver=0 "
FLAGS+="-only-output-states-covering-new "
FLAGS+="-simplify-sym-indices "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "

function run_klee {
    max_time=$1
    max_inst=$2
    ${VANILLA_KLEE} ${FLAGS} \
        -max-time=${max_time} \
        -max-instructions=${max_inst} \
        -use-cex-cache=1 \
        -use-branch-cache=1 \
        ${BC_FILE} ${SIZE}
}

function run_cache {
    max_time=$1
    max_inst=$2
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        -max-time=${max_time} \
        -max-instructions=${max_inst} \
        -use-sym-addr \
        -use-cex-cache=1 \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${SIZE}
}

function run_dsmm {
    max_time=$1
    max_inst=$2
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        -max-time=${max_time} \
        -max-instructions=${max_inst} \
        -use-sym-addr \
        -use-rebase=1 \
        -use-recursive-rebase=1 \
        -reuse-segments \
        -use-cex-cache=1 \
        -use-branch-cache=1 \
        ${BC_FILE} ${SIZE}
}

function run_dsmm_cache {
    max_time=$1
    max_inst=$2
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        -max-time=${max_time} \
        -max-instructions=${max_inst} \
        -use-sym-addr \
        -use-rebase=1 \
        -use-recursive-rebase=1 \
        -use-cex-cache=1 \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${SIZE}
}

ulimit -s unlimited
