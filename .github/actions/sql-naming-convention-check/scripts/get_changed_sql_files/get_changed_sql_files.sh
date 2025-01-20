#!/usr/bin/env bash
set -Eeuo pipefail

BASE_BRANCH="$1"
COMPARE_BRANCH="$2"

git fetch origin "${BASE_BRANCH}" "${COMPARE_BRANCH}"

declare -a CHANGED_FILES=()

while IFS= read -r file; do
  CHANGED_FILES+=("$file")
done < <(git diff --name-only "origin/${BASE_BRANCH}...origin/${COMPARE_BRANCH}" |
  grep -E '\.sql$' || true)

if [ "${#CHANGED_FILES[@]}" -eq 0 ]; then
  exit 0
fi

printf "%s\n" "${CHANGED_FILES[@]}" >sql_files.txt
