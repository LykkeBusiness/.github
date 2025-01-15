# SQL Migration Changelog Check GitHub Action

This GitHub Action verifies that any new or modified SQL migration (and corresponding rollback) scripts are documented in your project's `CHANGELOG.md`. By running this check, you can ensure that all database-related changes are consistently recorded in your changelog, keeping your documentation accurate and up-to-date.

## Features

- **Branch Comparison for Migration Scripts:**  
  Uses two branches (`base-branch` and `compare-branch`) to identify SQL migration script changes.  

- **CHANGELOG.md Validation:**  
  Checks that each identified migration script is referenced in `CHANGELOG.md`. If a migration script is missing from the changelog, it’s flagged as a violation.

- **Action Outputs:**  
  Returns violations as a base64-encoded string. If no mismatches are found, the result will be empty.

## Inputs

- `base-branch` (required, default: `master`):  
  The name of the branch to use as the baseline for comparison.

- `compare-branch` (required):  
  The name of the branch containing potential new or modified SQL migration scripts to check.

## Outputs

- `validation-result`:  
  A base64-encoded string listing all migration scripts that do not have a matching entry in `CHANGELOG.md`. If no violations are detected, this output is empty.

## Usage

Below is an example of how you might use this action within a workflow:

```yaml
name: Validate SQL Migration Changelog
on:
  pull_request:
    branches: [ master ]

jobs:
  sql_changelog_check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Run SQL Migration Changelog Check
        uses: ./.github/actions/sql_migration_changelog_check
        with:
          base-branch: 'master'
          compare-branch: 'feature-branch'

      - name: Print Validation Result
        run: |
          echo "Decoded validation-result:"
          echo "${{ fromBase64(steps.sql_changelog_check.outputs.validation-result) }}"
```

### Interpreting the Results

- If any migration scripts are missing corresponding references in `CHANGELOG.md`, `validation-result` will contain their filenames in base64-encoded form. You can decode the output in a subsequent step for readable results.
- If all migration scripts are properly referenced in the changelog, `validation-result` will be empty.

## Examples

**Scenario:**
- **New or Updated Migration Scripts Found:**  
  - `scripts/migrations/[MIGRATION]_create_orders_table.sql`
  - `scripts/migrations/[ROLLBACK]_create_orders_table.sql`

- **Missing Changelog Reference:**  
  - `CHANGELOG.md` does not mention `[MIGRATION]_create_orders_table.sql`.

**Violations:**
- `[MIGRATION]_create_orders_table.sql`  
  (No corresponding entry in `CHANGELOG.md`)

## Troubleshooting

- **No Migration Scripts Detected:**  
  If the action finds no new or updated migration scripts when comparing branches, it concludes with no violations. This is expected if there are no database changes in the pull request.

- **Incorrect Branch Names:**  
  Ensure both `base-branch` and `compare-branch` exist in your repository and are spelled correctly. If the action fails to analyze one of the branches, verify permissions or branch naming.

- **Failing on Violations:**  
  The action does not fail the workflow by default if violations exist. To fail the workflow, you can add a step after decoding the `validation-result` output and exit with a non-zero code if any violations are present.

- **Maintaining the Changelog Structure:**  
  Ensure your `CHANGELOG.md` has a consistent format that can be validated. If scripts are referenced but not recognized by the validation logic, review any custom formatting used in the changelog.