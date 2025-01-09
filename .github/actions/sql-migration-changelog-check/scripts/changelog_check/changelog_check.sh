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

# Directory to search for CHANGELOG file. Default is the current directory.
SEARCH_DIR=${2:-.}

CHANGELOG_FILE_PATH=$(find "$SEARCH_DIR" -type f -name "CHANGELOG.md")

if [ -z "$CHANGELOG_FILE_PATH" ]; then
    echo "Error: CHANGELOG.md file not found in the directory '$SEARCH_DIR'."
    exit 0
fi

INVALID_FILES=()

while IFS= read -r file; do
    [[ -z "$file" ]] && continue

    filename=$(basename "$file")

    if [[ $filename == "[MIGRATION]"* ]]; then
        if ! grep -Fq "### Migration: <<<$filename>>> [MANUAL]" "$CHANGELOG_FILE_PATH"; then
            INVALID_FILES+=("$file")
        fi
    elif [[ $filename == "[ROLLBACK]"* ]]; then
        if ! grep -Fq "### Rollback: <<<$filename>>>" "$CHANGELOG_FILE_PATH"; then
            INVALID_FILES+=("$file")
        fi
    else
        INVALID_FILES+=("$file")
    fi
done <"$MIGRATION_SCRIPTS_LIST"

if ((${#INVALID_FILES[@]} > 0)); then
    printf '%s\n' "${INVALID_FILES[@]}"
fi

exit 0
