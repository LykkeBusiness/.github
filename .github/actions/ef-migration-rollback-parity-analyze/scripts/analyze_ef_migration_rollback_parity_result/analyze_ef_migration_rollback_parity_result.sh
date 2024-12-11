#!/usr/bin/env bash
set -Eeuo pipefail

ENCODED_RESULT="$1"

# Decode the Base64-encoded result
validation_result=$(echo "$ENCODED_RESULT" | base64 --decode)

# Check if the result is non-empty
if [[ -n "$validation_result" ]]; then
    echo "Rollback scripts are missing for the following EF Core migrations:"
    echo "$validation_result" | while IFS= read -r line; do
        echo "- $line"
    done
    exit 1
fi
