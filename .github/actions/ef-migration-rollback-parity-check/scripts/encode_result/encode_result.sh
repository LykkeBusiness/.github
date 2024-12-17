#!/usr/bin/env bash
set -Eeuo pipefail

RESULT_FILE="$1"

if [[ -s "$RESULT_FILE" ]]; then
    ENCODED=$(base64 -w0 "$RESULT_FILE")
else
    ENCODED=""
fi

echo "validation-result=$ENCODED"
