#!/usr/bin/env bash
set -Eeuox pipefail

# Directory to search for SQL scripts. Default is the current directory.
SEARCH_DIR=${1:-.}

MIGRATION_SCRIPTS=$(find "$SEARCH_DIR" -type f -name "\[MIGRATION\]*.sql")

if [ -z "$MIGRATION_SCRIPTS" ]; then
  exit 0
fi

echo "$MIGRATION_SCRIPTS" >migration_scripts.txt
