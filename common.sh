#!/bin/bash

FLAGS=""

CACHE_FLAGS=""
CACHE_FLAGS+="-use-node-cache-stp=1 "
CACHE_FLAGS+="-use-global-id=1 "

function run_validation {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -output-dir=${OUTPUT_DIR} \
        -use-sym-addr \
        -use-cex-cache=1 \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        -collect-query-stats \
        -validate-caching \
        ${BC_FILE} ${ARGS}
}

function run_merge_validation {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -output-dir=${OUTPUT_DIR} \
        -use-sym-addr \
        -use-rebase=1 \
        -use-recursive-rebase=1 \
        -use-cex-cache=1 \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        -collect-query-stats \
        -validate-caching \
        ${BC_FILE} ${ARGS}
}

function run_klee {
    ${VANILLA_KLEE} ${FLAGS} \
        ${SEARCH} \
        -output-dir=${OUTPUT_DIR} \
        -use-cex-cache=1 \
        -use-branch-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_cache {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -output-dir=${OUTPUT_DIR} \
        -use-sym-addr \
        -use-cex-cache=1 \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_merge {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -output-dir=${OUTPUT_DIR} \
        -use-sym-addr \
        -use-rebase=1 \
        -use-recursive-rebase=1 \
        -reuse-segments \
        -use-cex-cache=1 \
        -use-branch-cache=1 \
        ${BC_FILE} ${ARGS}
}

function run_merge_cache {
    ${KLEE} ${FLAGS} ${CACHE_FLAGS} \
        ${SEARCH} \
        -output-dir=${OUTPUT_DIR} \
        -use-sym-addr \
        -use-rebase=1 \
        -use-recursive-rebase=1 \
        -use-cex-cache=1 \
        -use-branch-cache=0 \
        -use-iso-cache=1 \
        ${BC_FILE} ${ARGS}
}
