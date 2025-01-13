#!/usr/bin/env bash
set -Eeuox pipefail

BASE_BRANCH="$1"
COMPARE_BRANCH="$2"

git fetch origin "${BASE_BRANCH}" "${COMPARE_BRANCH}"

CHANGED_FILES=()

while IFS= read -r file; do
    CHANGED_FILES+=("$file")
done < <(git diff --name-only "origin/${BASE_BRANCH}...origin/${COMPARE_BRANCH}" |
    grep -E 'Migrations/[0-9]{14}_.+\.cs$' |
    grep -v 'Designer\.cs$' || true)

while IFS= read -r file; do
    CHANGED_FILES+=("$file")
done < <(git diff --name-only "origin/${BASE_BRANCH}...origin/${COMPARE_BRANCH}" |
    grep -E '\[ROLLBACK\]_.+\.sql$' || true)

if [ "${#CHANGED_FILES[@]}" -eq 0 ]; then
    echo "No EF Core migration or SQL rollback files found in the changes between $BASE_BRANCH and $COMPARE_BRANCH"
    exit 0
fi

printf "%s\n" "${CHANGED_FILES[@]}" >ef_migration_files.txt
