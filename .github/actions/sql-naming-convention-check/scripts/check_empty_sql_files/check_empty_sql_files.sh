#!/usr/bin/env bash
set -Eeuo pipefail

if [ ! -f sql_files.txt ] || [ ! -s sql_files.txt ]; then
    echo "No SQL files found to validate."
    # Set empty validation result
    echo "validation-result=" >> "$GITHUB_OUTPUT"
    exit 0
fi
