#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh

FLAGS=""
FLAGS+="-use-forked-solver=0 "
FLAGS+="-libc=uclibc "
FLAGS+="-search=dfs "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-only-output-states-covering-new "

SIZE=15
BC_FILE=${CURRENT_DIR}/test_driver.bc

DEPTH=0
K_CONTEXT=4

function run_klee {
    ${VANILLA_KLEE} \
        ${FLAGS} \
        ${BC_FILE} ${SIZE}
}

function run_klee_smm {
    ${KLEE_SMM} \
        ${FLAGS} \
        -pts \
        -flat-memory \
        ${BC_FILE} ${SIZE}
}

function run_with_rebase {
    ${KLEE} ${FLAGS} \
        -use-sym-addr \
        -use-rebase \
        -use-global-id=1 \
        -use-recursive-rebase=1 \
        -reuse-arrays=0 \
        -reuse-segments=1 \
        -use-context-resolve=1 \
        -use-kcontext=${K_CONTEXT} \
        -rebase-reachable=0 \
        -reachability-depth=${DEPTH} \
        -use-batch-rebase=0 \
        -use-ahead-rebase=1 \
        ${BC_FILE} ${SIZE}
}

function run_context_test {
    for i in {1..4}; do
        K_CONTEXT=${i}
        run_with_rebase
    done
}

ulimit -s unlimited

run_klee
run_klee_smm
run_with_rebase
