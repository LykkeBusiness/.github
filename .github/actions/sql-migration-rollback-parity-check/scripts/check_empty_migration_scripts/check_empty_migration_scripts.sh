#!/usr/bin/env bash
set -Eeuo pipefail

if [ ! -f migration_scripts.txt ] || [ ! -s migration_scripts.txt ]; then
    echo "No migration script files found."
    # Set empty validation result
    echo "validation-result=" >>"$GITHUB_OUTPUT"
    exit 0
fi
