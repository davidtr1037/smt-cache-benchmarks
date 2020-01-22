#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: <report_dir>"
    exit 1
fi

REPORT_DIR=$1
CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
BUILD_DIR=${CURRENT_DIR}

lcov --rc lcov_branch_coverage=1 -c -d ${BUILD_DIR} -o out.info
genhtml --branch-coverage out.info -o ${REPORT_DIR}
