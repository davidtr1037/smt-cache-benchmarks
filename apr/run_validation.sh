#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

PROGRAM_DIR=${ARTIFACT_DIR}/validation/apr
mkdir -p ${PROGRAM_DIR}

OUTPUT_DIR=${PROGRAM_DIR}/out-fmm run_validation
OUTPUT_DIR=${PROGRAM_DIR}/out-dsmm run_merge_validation
