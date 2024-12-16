#!/usr/bin/env bash
set -Eeuo pipefail

if [ ! -f sql_files.txt ] || [ ! -s sql_files.txt ]; then
    echo "No SQL files found to validate."
    # Set empty validation result
    echo "sql-files-changed=false" >>"$GITHUB_OUTPUT"
    exit 0
fi

echo "sql-files-changed=true" >>"$GITHUB_OUTPUT"
