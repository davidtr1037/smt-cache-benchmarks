#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

run_klee_qc_only
run_cache_qc_only
run_klee
run_cache
