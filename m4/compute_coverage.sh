#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: <klee_out_dir>"
    exit 1
fi

TEST_DIR=$1
CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
BINARY=${CURRENT_DIR}/build_gcov/src/m4

for f in ${TEST_DIR}/*; do
    ./build_gcov/src/m4 < $f
done

