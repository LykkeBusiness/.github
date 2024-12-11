# SQL Naming Convention Analyze GitHub Action

This GitHub Action is designed to analyze the results of an SQL naming convention validation step. It takes a base64-encoded string that represents any violations found in changed SQL files and:

1. Decodes the results.
2. Prints out a human-readable list of violations if any are present.
3. Exits with a non-zero status if violations are detected, helping ensure that non-compliant SQL file names prevent a workflow from passing.

## Features

- **Automatic Decoding**: Takes a base64-encoded result and converts it back into plain text.
- **Clear Violation Reporting**: Prints each violation on its own line, making it easy to understand which files failed the naming policy.
- **Failure on Violations**: Exits the action with a non-zero status if violations exist, causing the GitHub Actions job to fail and preventing merges of non-compliant changes.

## Inputs

- `validation-result` (required): A base64-encoded string of validation results.  
  Typically produced by a previous step or action that checks SQL naming conventions.

## Outputs

None. Instead of producing outputs, this action fails or passes the current job depending on whether violations exist.

## Usage Example

Below is an example of how you might integrate this action into a workflow after running the SQL naming convention validation:

```yaml
jobs:
  sql_naming_check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run SQL naming convention check
        id: validate_sql_naming
        # This step would be your own action or script that produces the base64-encoded validation-result.
        run: |
          # Example: produce validation_result.txt with violations and then encode it
          echo "file1.sql: Missing prefix" > validation_result.txt
          echo "validation-result=$(base64 -w0 validation_result.txt)" >> $GITHUB_OUTPUT

      - name: Analyze SQL naming convention results
        uses: ./.github/actions/sql-naming-convention-analyze
        with:
          validation-result: ${{ steps.validate_sql_naming.outputs.validation-result }}
```

If violations are found, the action prints them and fails the job. If none are found, the action completes successfully and the workflow continues.