# SQL Migration-Rollback Parity Check GitHub Action

This GitHub Action ensures that for every SQL migration script found in your repository, there is a corresponding rollback script. By running this check, you can enforce parity between migration and rollback scripts in your CI/CD pipeline, ensuring database changes can be reversed when necessary.

## Features

- **Automated Detection of Migration Scripts:**
  Identifies SQL files that represent migration scripts within the target branch.
  
- **Rollback Parity Validation:**
  Verifies that each detected migration script has a matching rollback script. If a migration script lacks a corresponding rollback, it’s flagged as a violation.
  
- **Action Outputs:**
  Returns violations as a base64-encoded string. If no mismatches are found, the result will be empty.

## Inputs

- `target-branch` (required):  
  The branch to analyze for SQL migration-rollback parity (usually, it is feature branch).

## Outputs

- `validation-result`:  
  A base64-encoded string listing all migration scripts that do not have a matching rollback script. If no violations are detected, this output is empty.

## Usage

Below is an example of how you might use this action within a workflow:

```yaml
name: Validate SQL Migration-Rollback Parity
on:
  pull_request:
    branches: [ master ]

jobs:
  sql_parity_check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Run SQL Migration-Rollback Parity Check
        uses: ./.github/actions/sql_migration_rollback_parity_check
        with:
          target-branch: 'master'
      
      - name: Print Validation Result
        run: |
          echo "Decoded validation-result:"
          echo "${{ fromBase64(steps.sql_parity_check.outputs.validation-result) }}"
```

### Interpreting the Results

- If any migration scripts do not have corresponding rollback scripts, `validation-result` will contain their filenames in base64-encoded form. You can decode the output in a subsequent step for readable results.
- If all migration scripts have matching rollback scripts, `validation-result` will be empty.

## Examples

**Scenario:**
- Migration Scripts Found:  
  - `[MIGRATION]_add_new_column.sql`
  - `[MIGRATION]_create_orders_table.sql`
  
- Corresponding Rollback Scripts Found:  
  - `[ROLLBACK]_add_new_column.sql`
  
- Missing Rollback:  
  - `[ROLLBACK]_create_orders_table.sql` is not present.

**Violations:**
- `[MIGRATION]_create_orders_table.sql` (no matching `[ROLLBACK]_create_orders_table.sql`)

## Troubleshooting

- **No Migration Scripts Found:**  
  If the action finds no migration scripts, it concludes with no violations. This is expected if no migrations exist in the target branch.
  
- **Incorrect Branch Name:**  
  Ensure the `target-branch` exists in your repository. If the action fails to find or analyze the branch, verify the branch name and repository access.
  
- **Failing on Violations:**
  By default, the action does not fail the workflow if violations exist. If you want to fail the workflow, you can add a step after decoding the `validation-result` output and exit with a non-zero code if violations are present.