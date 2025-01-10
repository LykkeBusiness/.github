#!/usr/bin/env bash
set -Eeuox pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 <migration_scripts.txt> [search_dir]"
    exit 1
fi

MIGRATION_SCRIPTS_LIST="$1"
SEARCH_DIR="${2:-.}"

if [[ ! -f $MIGRATION_SCRIPTS_LIST ]]; then
    echo "Error: File '$MIGRATION_SCRIPTS_LIST' does not exist."
    exit 1
fi

CHANGELOG_FILE_PATH="$(find "$SEARCH_DIR" -type f -name "CHANGELOG.md" -print -quit)"

if [ -z "$CHANGELOG_FILE_PATH" ]; then
    echo "Error: CHANGELOG.md file not found in the directory '$SEARCH_DIR'."
    exit 0
fi

echo "CHANGELOG file to be checked: $CHANGELOG_FILE_PATH"

INVALID_FILES=()

while IFS= read -r file; do
    [[ -n "$file" ]] || continue
    filename="$(basename "$file")"
    case "$filename" in
    "[MIGRATION]"*)
        grep -Fxq "### Migration: <<<$filename>>> [MANUAL]" "$CHANGELOG_FILE_PATH" || INVALID_FILES+=("$file")
        ;;
    "[ROLLBACK]"*)
        grep -Fxq "### Rollback: <<<$filename>>>" "$CHANGELOG_FILE_PATH" || INVALID_FILES+=("$file")
        ;;
    *)
        INVALID_FILES+=("$file")
        ;;
    esac
done <"$MIGRATION_SCRIPTS_LIST"

if ((${#INVALID_FILES[@]} > 0)); then
    printf '%s\n' "${INVALID_FILES[@]}"
fi

exit 0
