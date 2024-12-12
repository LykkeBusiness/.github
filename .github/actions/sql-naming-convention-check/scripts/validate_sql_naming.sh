#!/bin/bash

INVALID_FILES=()

for file in $SQL_FILES; do
  filename=$(basename "$file")
  if [[ ! $filename =~ ^\[MIGRATION\]_.*\.sql$ && ! $filename =~ ^\[ROLLBACK\]_.*\.sql$ && ! $filename =~ ^\[SCRIPT\]_.*\.sql$ ]]; then
    INVALID_FILES+=("$file: Does not start with a valid prefix ([MIGRATION]_, [ROLLBACK]_, or [SCRIPT]_).")
  elif [[ $filename =~ ^\[[A-Z]+\]_\.sql$ ]]; then
    INVALID_FILES+=("$file: Contains only the prefix without a specific name.")
  fi
done

if [[ ${#INVALID_FILES[@]} -ne 0 ]]; then
  echo "The following SQL files do not follow the naming convention:"
  for invalid in "${INVALID_FILES[@]}"; do
    echo "- $invalid"
  done
  exit 1
else
  echo "All SQL files follow the naming convention."
fi
