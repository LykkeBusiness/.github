#!/usr/bin/env bash
set -Eeuo pipefail

# Directory to search for SQL scripts. Default is the current directory.
SEARCH_DIR=${1:-.}

MIGRATION_SCRIPTS=()

while IFS= read -r script; do
  MIGRATION_SCRIPTS+=("$script")
done < <(find "$SEARCH_DIR" -type f -name "\[MIGRATION\]*.sql" || true)

if [ "${#MIGRATION_SCRIPTS[@]}" -eq 0 ]; then
  exit 0
fi

printf "%s\n" "${MIGRATION_SCRIPTS[@]}" >migration_scripts.txt
