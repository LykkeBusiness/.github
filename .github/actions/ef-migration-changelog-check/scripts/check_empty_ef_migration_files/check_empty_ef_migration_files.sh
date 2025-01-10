#!/usr/bin/env bash
set -Eeuo pipefail

if [ ! -f ef_migration_files.txt ] || [ ! -s ef_migration_files.txt ]; then
    echo "No EF Core migration or SQL rollback files found."
    echo "ef-migration-files-changed=false" >>"$GITHUB_OUTPUT"
    exit 0
fi

echo "ef-migration-files-changed=true" >>"$GITHUB_OUTPUT"
