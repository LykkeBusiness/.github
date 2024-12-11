# analyze_migration_rollback_result.sh

This script decodes a base64-encoded validation result string and checks whether any migration scripts lack corresponding rollback scripts. If missing rollbacks are detected, it prints them out and signals a failure (non-zero exit code), which can be used to fail a CI/CD pipeline.

## What It Does

1. **Decoding Results**:  
   The script takes a single argument—a base64-encoded string—and decodes it to produce a human-readable output.

2. **Rollback Parity Check**:  
   - If the decoded output is empty, it indicates that all migration scripts have corresponding rollback scripts. The script then exits with a zero status code.
   - If the decoded output is non-empty, it lists the migration scripts that are missing rollbacks and exits with a non-zero status code.

## Usage

```bash
./analyze_migration_rollback_result.sh <BASE64_ENCODED_STRING>
```

**Parameters:**

- `<BASE64_ENCODED_STRING>`:  
  A base64-encoded string that, when decoded, includes one or more migration script names without corresponding rollback scripts.

## Examples

**All Rollbacks Present:**

```bash
./analyze_migration_rollback_result.sh ""
```

- Since the input is empty, there are no violations. The script exits with `exit 0` and does not produce any output.

**Missing Rollbacks:**

```bash
BASE64_RESULT=$(echo "[MIGRATION]_create_orders_table.sql" | base64 -w0)
./analyze_migration_rollback_result.sh "$BASE64_RESULT"
```

**Output:**
```
Rollback scripts are missing for the following migrations:
- [MIGRATION]_create_orders_table.sql
```

The script exits with a non-zero status code (e.g., `exit 1`), signaling a violation.

## Exit Codes

- **0**: All rollback scripts are present for each migration script (no violations).
- ******Non-Zero**: At least one migration script is missing a corresponding rollback script, indicating a violation.