#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <sql_files_list.txt>"
  exit 1
fi

SQL_FILES_LIST=$1
if [[ ! -f $SQL_FILES_LIST ]]; then
  echo "Error: File '$SQL_FILES_LIST' does not exist."
  exit 1
fi

INVALID_FILES=()

while IFS= read -r file; do
  filename=$(basename "$file")

  case "$filename" in
  "[MIGRATION]_"*.sql | "[ROLLBACK]_"*.sql | "[SCRIPT]_"*.sql)
    # The pattern below matches if prefix is present but there's nothing before .sql.
    if [[ $filename =~ ^\[[A-Z]+\]_\.sql$ ]]; then
      INVALID_FILES+=("$file: Contains only the prefix without a specific name.")
    fi
    ;;
  # Anything else is invalid
  *)
    INVALID_FILES+=("$file: Does not start with a valid prefix ([MIGRATION]_, [ROLLBACK]_, or [SCRIPT]_).")
    ;;
  esac
done <"$SQL_FILES_LIST"

if ((${#INVALID_FILES[@]} > 0)); then
  printf '%s\n' "${INVALID_FILES[@]}"
fi

exit 0
