# SQL Migration-Rollback Parity Analyze GitHub Action

This GitHub Action is designed to analyze the results of a migration-rollback parity validation step. It takes a base64-encoded string that represents any parity violations found between your migration and rollback SQL files and:

1. Decodes the results.
2. Prints out a human-readable list of violations if any are present.
3. Exits with a non-zero status if violations are detected, helping ensure that migrations and their corresponding rollbacks remain in sync.

## Features

- **Automatic Decoding**: Accepts a base64-encoded string and converts it back to plain text.
- **Clear Violation Reporting**: Prints each detected violation line-by-line, making it easy to identify which migrations and rollbacks are not in parity.
- **Failure on Violations**: Exits the action with a non-zero status if parity issues exist, stopping the GitHub Actions job and preventing merges of non-compliant changes.

## Inputs

- `validation-result` (required): A base64-encoded string of parity validation results.  
  Typically produced by a previous step or action that checks for parity between migration and rollback scripts.

## Outputs

None. This action does not produce outputs. Instead, it either passes the job (if no violations are found) or fails it (if violations are present).

## Usage Example

Below is an example of how you might integrate this action into a workflow after running your parity check:

```yaml
jobs:
  migration_rollback_parity_check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run Migration-Rollback Parity Check
        id: validate_migration_rollback
        # This step would be your own action or script that produces the base64-encoded validation result.
        run: |
          # Example: produce parity_result.txt with violations, then encode it
          echo "[MIGRATION]_migration1.sql" > parity_result.txt
          echo "validation-result=$(base64 -w0 parity_result.txt)" >> $GITHUB_OUTPUT

      - name: Analyze Migration-Rollback Parity Results
        uses: ./.github/actions/sql-migration-rollback-parity-analyze
        with:
          validation-result: ${{ steps.validate_migration_rollback.outputs.validation-result }}
```

If violations are found, the action prints them and fails the job. If none are found, the action completes successfully and the workflow continues.