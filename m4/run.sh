#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh

MAX_MEMORY=8000

FLAGS=""
FLAGS+="-libc=uclibc "
FLAGS+="-posix-runtime "
FLAGS+="-search=dfs "
FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-use-forked-solver=0 "
FLAGS+="-only-output-states-covering-new "
FLAGS+="-switch-type=internal "
FLAGS+="-simplify-sym-indices "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "

DEPTH=0
K_CONTEXT=4
SPLIT_THRESHOLD=300
PARTITION=128

BC_FILE=${CURRENT_DIR}/build/src/m4.bc
ARGS="-sym-files 1 1 -sym-stdin ${CURRENT_DIR}/m4.input -H37 -G"

function run_klee {
    ${VANILLA_KLEE} ${FLAGS} \
        ${BC_FILE} ${ARGS}
}

function run_klee_smm {
    ${KLEE_SMM} ${FLAGS} \
        -pts \
        -flat-memory \
        ${BC_FILE} ${ARGS}
}

function run_with_rebase {
    ${KLEE} ${FLAGS} \
        -use-sym-addr \
        -use-rebase \
        -use-global-id=1 \
        -use-recursive-rebase=1 \
        -reuse-arrays=0 \
        -reuse-segments=1 \
        -use-kcontext=${K_CONTEXT} \
        -use-context-resolve=1 \
        -rebase-reachable=0 \
        -reachability-depth=${DEPTH} \
        -use-batch-rebase=0 \
        -use-ahead-rebase=1 \
        ${BC_FILE} ${ARGS}
}

function run_context_test {
    for i in {0..4}; do
        K_CONTEXT=${i}
        run_with_rebase
    done
}

function run_split {
    ${KLEE} ${FLAGS} \
        -use-sym-addr \
        -split-objects \
        -split-threshold=${SPLIT_THRESHOLD} \
        -partition-size=${PARTITION} \
        ${BC_FILE} ${ARGS}
}

ulimit -s unlimited

run_klee
run_klee_smm
run_with_rebase
