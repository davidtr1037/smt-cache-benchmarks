#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ../config.sh

UTILS_FILE=${CURRENT_DIR}/utils.txt
SANDBOX_DIR=/tmp/env
SANDBOX=${SANDBOX_DIR}/sandbox

ARGS="--sym-args 0 1 10 --sym-args 0 2 2 --sym-files 1 8 --sym-stdin 8 --sym-stdout"
MAX_TIME=3600
MAX_MEMORY=4000

FLAGS+="--max-memory=${MAX_MEMORY} "
FLAGS+="--max-time=${MAX_TIME} "
FLAGS+="--search=dfs "
FLAGS+="--use-forked-solver=1 "
FLAGS+="--disable-inlining "
FLAGS+="--optimize "
FLAGS+="--libc=uclibc "
FLAGS+="--posix-runtime "
FLAGS+="--external-calls=all "
FLAGS+="--only-output-states-covering-new "
FLAGS+="--env-file=test.env "
FLAGS+="--run-in-dir=${SANDBOX} "
FLAGS+="--watchdog "
FLAGS+="--switch-type=internal "
FLAGS+="--simplify-sym-indices "

function reset {
    rm -rf ${SANDBOX_DIR}
    mkdir -p ${SANDBOX_DIR}
    tar xf ${CURRENT_DIR}/sandbox.tgz -C ${SANDBOX_DIR}
}

function run_klee {
    bc_file=$1
    name=$2
    reset
    ${VANILLA_KLEE} ${FLAGS} \
        -output-dir=${CURRENT_DIR}/build/src/klee-out-${name} \
        ${bc_file} ${ARGS}
}

function run_with_symaddr {
    bc_file=$1
    ${KLEE} ${FLAGS} \
        -use-sym-addr \
        -use-rebase \
        -use-global-id=1 \
        -use-recursive-rebase=1 \
        ${bc_file} ${ARGS}
}

function run_all {
    log_file=${CURRENT_DIR}/out.log
    rm -rf ${log_file}
    for name in $(cat ${UTILS_FILE}); do
        bc_file=${CURRENT_DIR}/build/src/${name}.bc
        run_klee ${bc_file} ${name}
        echo "${name}: status = $?" >> ${log_file}
    done
}

ulimit -s unlimited

run_all
