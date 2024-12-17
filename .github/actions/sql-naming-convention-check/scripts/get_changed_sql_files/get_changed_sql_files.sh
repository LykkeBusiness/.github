#!/usr/bin/env bash
set -Eeuo pipefail

BASE_BRANCH="$1"
COMPARE_BRANCH="$2"

git fetch origin "${BASE_BRANCH}" "${COMPARE_BRANCH}"

CHANGED_FILES=$(git diff --name-only "origin/${BASE_BRANCH}...origin/${COMPARE_BRANCH}" | grep -E '\.sql$' || true)

if [ -z "$CHANGED_FILES" ]; then
  exit 0
fi

echo "$CHANGED_FILES" >sql_files.txt
