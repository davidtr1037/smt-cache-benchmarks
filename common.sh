#!/bin/bash

N=3

function run_all {
    for ((n=0;n<${N};n++)); do
        echo "iteration ${n}"
        run_with_rebase "-search=dfs"
        run_with_rebase "-search=bfs"
        run_with_rebase ""
    done
}

function run_reuse {
    for ((n=0;n<${N};n++)); do
        echo "iteration ${n}"
        CONTEXT_RESOLVE=0 REUSE=1 run_with_rebase "-search=dfs"
    done
}

function run_context_resolve {
    N=1
    for ((n=0;n<${N};n++)); do
        echo "iteration ${n}"
        CONTEXT_RESOLVE=1 K_CONTEXT=4 REUSE=0 run_with_rebase "-search=dfs"
    done
}

function run_no_opt {
    N=1
    for ((n=0;n<${N};n++)); do
        echo "iteration ${n}"
        CONTEXT_RESOLVE=0 REUSE=0 run_with_rebase "-search=dfs"
    done
}
