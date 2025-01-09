#!/usr/bin/env bash
set -Eeuo pipefail

BASE_BRANCH="$1"
COMPARE_BRANCH="$2"

git fetch origin "${BASE_BRANCH}" "${COMPARE_BRANCH}"

CHANGED_FILES=$(git diff --name-only "origin/${BASE_BRANCH}...origin/${COMPARE_BRANCH}" |
    grep -E '\[(MIGRATION|ROLLBACK)\]_.+\.sql$' || true)

if [ -z "$CHANGED_FILES" ]; then
    echo "No migration or rollback SQL files found in the changes between $BASE_BRANCH and $COMPARE_BRANCH"
    exit 0
fi

echo "$CHANGED_FILES" >migration_scripts.txt
