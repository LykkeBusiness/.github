#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <ef_migration_files.txt>"
    exit 1
fi

MIGRATION_FILES_LIST=$1
if [[ ! -f $MIGRATION_FILES_LIST ]]; then
    echo "Error: File '$MIGRATION_FILES_LIST' does not exist."
    exit 1
fi

INVALID_FILES=()

while IFS= read -r file; do
    [[ -z "$file" ]] && continue

    filename=$(basename "$file")

    # For EF Migrations, the naming pattern is:
    #   yyyyMMddHHmmss_<migration-name>.cs
    # We just need to strip off the '.cs' extension. The resulting
    # migration_name will include the timestamp and the underscore, for example:
    #   filename: 20240101093000_AddUsers.cs
    #   migration_name: 20240101093000_AddUsers
    #
    # We'll then look for [ROLLBACK]_<migration_name>.sql
    migration_name=${filename%.cs}

    rollback_file=$(find . -type f -name "\[ROLLBACK\]_${migration_name}.sql" -print -quit)

    if [[ -z "$rollback_file" ]]; then
        INVALID_FILES+=("$file")
    fi
done <"$MIGRATION_FILES_LIST"

if ((${#INVALID_FILES[@]} > 0)); then
    printf '%s\n' "${INVALID_FILES[@]}"
fi

exit 0
