#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

PROGRAM_DIR=${ARTIFACT_DIR}/overhead_fmm
mkdir -p ${PROGRAM_DIR}

OUTPUT_DIR=${PROGRAM_DIR}/out-klee-libosip run_klee ${MAX_TIME_INCREASED} ${MAX_INST}
OUTPUT_DIR=${PROGRAM_DIR}/out-cache-libosip run_cache ${MAX_TIME_INCREASED} ${MAX_INST}
