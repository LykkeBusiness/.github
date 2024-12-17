#!/usr/bin/env bash
set -Eeuo pipefail

BASE_BRANCH="$1"
COMPARE_BRANCH="$2"

git fetch origin "${BASE_BRANCH}" "${COMPARE_BRANCH}"

CHANGED_FILES=$(git diff --name-only "origin/${BASE_BRANCH}...origin/${COMPARE_BRANCH}" |
    grep -E 'Migrations/.+\.cs$' |
    grep -E '[0-9]{14}_.+\.cs$' |
    grep -v 'Designer\.cs$' || true)

if [ -z "$CHANGED_FILES" ]; then
    echo "No EF migration files found in the changes between $BASE_BRANCH and $COMPARE_BRANCH"
    exit 0
fi

echo "$CHANGED_FILES" >ef_migration_files.txt
