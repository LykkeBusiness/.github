# EF Core Migration Changelog Analyze GitHub Action

This GitHub Action is designed to analyze the contents of `CHANGELOG.md` to ensure that all EF Core migration and rollback files have corresponding entries. It takes a base64-encoded string that represents any discrepancies found between your EF Core migration files and the `CHANGELOG.md` file and:

1. Decodes the results.  
2. Prints out a human-readable list of missing or incorrect entries if any are present.  
3. Exits with a non-zero status if issues are detected, helping ensure that your `CHANGELOG.md` remains in sync with your EF Core migrations.

## Features

- **Automatic Decoding**: Accepts a base64-encoded string and converts it back to plain text.
- **Clear Reporting of Missing Entries**: Prints each detected discrepancy line-by-line, making it easy to identify which migrations or rollbacks lack proper documentation in `CHANGELOG.md`.
- **Failure on Issues**: Exits the action with a non-zero status if issues exist, stopping the GitHub Actions job and preventing merges of non-compliant changes.

## Inputs

- `validation-result` (required): A base64-encoded string of validation results.  
  Typically produced by a previous step or action that checks for the presence of EF Core migration file references in `CHANGELOG.md`.

## Outputs

None. This action does not produce outputs. Instead, it either passes the job (if no issues are found) or fails it (if issues are present).

## Usage Example

Below is an example of how you might integrate this action into a workflow after running your changelog check:

```yaml
jobs:
  ef-changelog_check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run EF Core Migration Changelog Check
        id: validate_ef_migration_changelog
        # This step would be your own action or script that produces the base64-encoded validation result.
        run: |
          # Example: produce changelog_result.txt with missing entries, then encode it
          echo "Missing entry for 20250102123045_AddCustomerTable.cs" > changelog_result.txt
          echo "validation-result=$(base64 -w0 changelog_result.txt)" >> $GITHUB_OUTPUT

      - name: Analyze EF Core Migration Changelog Results
        uses: ./.github/actions/ef_migration_changelog_analyze
        with:
          validation-result: ${{ steps.validate_sql_migration_changelog.outputs.validation-result }}
```

If discrepancies are found, the action prints them and fails the job. If none are found, the action completes successfully and the workflow continues.