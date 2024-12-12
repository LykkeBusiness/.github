#!/bin/bash

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
  if [[ ! $filename =~ ^\[MIGRATION\]_.*\.sql$ && ! $filename =~ ^\[ROLLBACK\]_.*\.sql$ && ! $filename =~ ^\[SCRIPT\]_.*\.sql$ ]]; then
    INVALID_FILES+=("$file: Does not start with a valid prefix ([MIGRATION]_, [ROLLBACK]_, or [SCRIPT]_).")
  elif [[ $filename =~ ^\[[A-Z]+\]_\.sql$ ]]; then
    INVALID_FILES+=("$file: Contains only the prefix without a specific name.")
  fi
done < "$SQL_FILES_LIST"

if [[ ${#INVALID_FILES[@]} -ne 0 ]]; then
  for invalid in "${INVALID_FILES[@]}"; do
    echo "$invalid"
  done
fi

exit 0