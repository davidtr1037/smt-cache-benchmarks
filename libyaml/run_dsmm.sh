#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

PROGRAM_DIR=${ARTIFACT_DIR}/overhead_dsmm
mkdir -p ${PROGRAM_DIR}

OUTPUT_DIR=${PROGRAM_DIR}/out-klee-libyaml run_dsmm ${MAX_TIME_INCREASED} ${MAX_INST}
OUTPUT_DIR=${PROGRAM_DIR}/out-cache-libyaml run_dsmm_cache ${MAX_TIME_INCREASED} ${MAX_INST}
