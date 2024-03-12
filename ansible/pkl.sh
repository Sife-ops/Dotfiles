#!/bin/bash
find . -name \*.pkl -type f -print0 |
    while IFS= read -d '' file; do
        b=$(basename $file)
        o="$(dirname $file)/${b%.pkl}.yml"
        pkl eval -f yaml $file |
            sed '1 s@^.*$@#!/usr/bin/env ansible-playbook\n---@' > $o
        chmod +x $o
    done

