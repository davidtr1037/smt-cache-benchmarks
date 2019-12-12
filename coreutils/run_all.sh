#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ../config.sh

SANDBOX_DIR=/tmp
SANDBOX=${SANDBOX_DIR}/sandbox
ARGS="--sym-args 0 1 10 --sym-args 0 2 2 --sym-files 1 8 --sym-stdin 8 --sym-stdout"
MAX_TIME=3600
MAX_MEMORY=4000

FLAGS+="--simplify-sym-indices "
FLAGS+="--write-cvcs "
FLAGS+="--write-cov "
FLAGS+="--output-module "
FLAGS+="--max-memory=${MAX_MEMORY} "
FLAGS+="--disable-inlining "
FLAGS+="--optimize "
FLAGS+="--use-forked-solver=0 "
FLAGS+="--use-cex-cache "
FLAGS+="--libc=uclibc "
FLAGS+="--posix-runtime "
FLAGS+="--external-calls=all "
FLAGS+="--only-output-states-covering-new "
FLAGS+="--env-file=test.env "
FLAGS+="--run-in-dir=${SANDBOX} "
FLAGS+="--max-sym-array-size=4096 "
FLAGS+="--max-instruction-time=30s "
FLAGS+="--max-time=${MAX_TIME} "
FLAGS+="--watchdog "
FLAGS+="--max-memory-inhibit=false  "
FLAGS+="--max-static-fork-pct=1 "
FLAGS+="--max-static-solve-pct=1 "
FLAGS+="--max-static-cpfork-pct=1 "
FLAGS+="--switch-type=internal "
FLAGS+="--search=dfs "
FLAGS+="--use-batching-search "
FLAGS+="--batch-instructions=10000 "

function reset {
    rm -rf ${SANDBOX}
    tar xf ${CURRENT_DIR}/sandbox.tgz -C ${SANDBOX_DIR}
}

function run_klee {
    bc_file=$1
    reset
    ${VANILLA_KLEE} ${FLAGS} \
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
    for name in $(cat utils.txt); do
        bc_file=${CURRENT_DIR}/build/src/${name}.bc
        run_klee ${bc_file}
        echo "${name}: status = $?" >> ${log_file}
    done
}

ulimit -s unlimited

run_all
