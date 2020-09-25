#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

run_dsmm ${MAX_TIME_INCREASED} ${MAX_INST}
run_dsmm_cache ${MAX_TIME_INCREASED} ${MAX_INST}
