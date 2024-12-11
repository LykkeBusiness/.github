# analyze_ef_migration_changelog_result.sh

This script decodes a base64-encoded validation result string and checks whether EF Core migration and rollback files mentionings are included or not into `CHANGELOG.md` file. If missing scripts inclusion is detected, it prints them out and signals a failure (non-zero exit code), which can be used to fail a CI/CD pipeline.

## What It Does

1. **Decoding Results**:  
   The script takes a single argument—a base64-encoded string—and decodes it to produce a human-readable output.

2. **EF Core Migration Changelog Check**:  
   - If the decoded output is empty, it indicates that all migration and rollback files have been included into `CHANGELOG.md` file. The script then exits with a zero status code.
   - If the decoded output is non-empty, it lists the scripts that are missing and exits with a non-zero status code.

## Usage

```bash
./analyze_ef_migration_changelog_result.sh <BASE64_ENCODED_STRING>
```

**Parameters:**

- `<BASE64_ENCODED_STRING>`:  
  A base64-encoded string that, when decoded, includes one or more SQL script file names (migrations and rollbacks) not included into `CHANGELOG.md` file.

## Examples

**All Scripts Included:**

```bash
./analyze_ef_migration_changelog_result.sh ""
```

- Since the input is empty, there are no violations. The script exits with `exit 0` and does not produce any output.

**Missing entries:**

```bash
BASE64_RESULT=$(echo "[ROLLBACK]_20241212141012_CreateOrdersTable.sql" | base64 -w0)
./analyze_ef_migration_changelog_result.sh "$BASE64_RESULT"
```

**Output:**
```
`CHANGELOG.md` lacks the following rollback scripts mentionings:
- [ROLLBACK]_20241212141012_CreateOrdersTable.sql
```

The script exits with a non-zero status code (e.g., `exit 1`), signaling a violation.

## Exit Codes

- **0**: No violations detected; all migration and rollback scripts have been included into `CHANGELOG.md` file.
- ******Non-Zero**: One or more migration and rollback files are missing from `CHANGELOG.md` file.