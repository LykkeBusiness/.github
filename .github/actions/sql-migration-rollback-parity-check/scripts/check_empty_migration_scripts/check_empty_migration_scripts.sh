#!/usr/bin/env bash
set -Eeuo pipefail

if [ ! -f migration_scripts.txt ] || [ ! -s migration_scripts.txt ]; then
    echo "No migration script files found."
    echo "migration-scripts-changed=false" >>"$GITHUB_OUTPUT"
    exit 0
fi

echo "migration-scripts-changed=true" >>"$GITHUB_OUTPUT"
