#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

PROGRAM_DIR=${ARTIFACT_DIR}/qc_dsmm/libxml2
mkdir -p ${PROGRAM_DIR}

OUTPUT_DIR=${PROGRAM_DIR}/out-klee run_merge
OUTPUT_DIR=${PROGRAM_DIR}/out-cache run_merge_cache
