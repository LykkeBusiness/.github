#!/usr/bin/env bash
set -Eeuox pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <migration_scripts.txt>"
    exit 1
fi

MIGRATION_SCRIPTS_LIST=$1
if [[ ! -f $MIGRATION_SCRIPTS_LIST ]]; then
    echo "Error: File '$MIGRATION_SCRIPTS_LIST' does not exist."
    exit 1
fi

INVALID_FILES=()

while IFS= read -r file; do
    [[ -z "$file" ]] && continue

    filename=$(basename "$file")
    migration_name=${filename#[MIGRATION]_}
    migration_name=${migration_name%.sql}

    echo "Checking for rollback file for migration: $migration_name"

    rollback_file=$(find . -type f -name "[ROLLBACK]_${migration_name}.sql" -print -quit)

    if [[ -z "$rollback_file" ]]; then
        echo "No rollback file found for migration: $file"
        INVALID_FILES+=("$file")
    else
        echo "Found rollback file: $rollback_file for migration: $file"
    fi
done <"$MIGRATION_SCRIPTS_LIST"

if ((${#INVALID_FILES[@]} > 0)); then
    printf '%s\n' "${INVALID_FILES[@]}"
fi

exit 0
