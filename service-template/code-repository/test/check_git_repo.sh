#!/usr/bin/env bash
# vim: set ft=sh

set -eux

CLONE_URL=$1

mkdir -p .output
cd .output
git clone ${CLONE_URL}
echo "$(basename ${CLONE_URL})"
cd ./$(basename ${CLONE_URL})
git push --dry-run --all
