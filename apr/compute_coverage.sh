#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: <klee_out_dir>"
    exit 1
fi

source ${CURRENT_DIR}/../config.sh
KLEE_OUT_DIR=$1
CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
BINARY=${CURRENT_DIR}/test_driver_gcov
SIZE=15

for f in ${KLEE_OUT_DIR}/*.ktest; do
    klee-replay ${BINARY} ${f} ${SIZE}
done

