#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh

BC_FILE=${CURRENT_DIR}/test_driver.bc
MAX_TIME=60
MAX_TIME_INCREASED=5400
MAX_INST=187749 # 60
MAX_INST=50000
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
FLAGS+="-use-query-log=all:kquery "

function run_klee {
    max_time=$1
    max_inst=$2
    ${VANILLA_KLEE} ${FLAGS} \
        -max-time=${max_time} \
        -max-instructions=${max_inst} \
        ${BC_FILE} ${SIZE}
}

function run_cache {
    max_time=$1
    max_inst=$2
    ${KLEE} ${FLAGS} \
        -max-time=${max_time} \
        -max-instructions=${max_inst} \
        -use-sym-addr \
        -use-branch-cache=1 \
        -use-iso-cache=0 \
        ${BC_FILE} ${SIZE}
}

ulimit -s unlimited

#run_klee ${MAX_TIME} 0
run_klee ${MAX_TIME_INCREASED} ${MAX_INST}
run_cache ${MAX_TIME_INCREASED} ${MAX_INST}
