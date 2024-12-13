# SQL Naming Convention Check GitHub Action

This GitHub Action validates SQL file naming conventions against a defined policy. The action checks for changed SQL files, ensures they follow a specific naming pattern, and outputs violations (if any) in a base64-encoded string. By integrating this action into your workflow, you can automatically enforce naming standards for SQL files in your repository’s CI/CD process.

## Features

- **Automatic Detection of Changed SQL Files:**  
  Compares two branches (base and compare) and identifies which `.sql` files have changed.
  
- **Naming Convention Enforcement:**  
  Validates that each changed SQL file starts with one of the required prefixes (`[MIGRATION]_`, `[ROLLBACK]_`, `[SCRIPT]_`) and includes a meaningful name after the prefix.
  
- **Action Outputs:**  
  If violations are found, they are returned in a base64-encoded format. If no violations exist, the result is empty.

## Inputs

- `base-branch` (required; default: `master`):  
  The reference branch used as the baseline for comparison (e.g., `master`).
  
- `compare-branch` (required):  
  The branch compared against the `base-branch` to detect changed SQL files.

## Outputs

- `validation-result`:  
  A base64-encoded string containing a list of files that violate the naming conventions. If no violations are found, this output is empty.

## Usage

Below is an example of how you might use this action in your workflow:

```yaml
name: Validate SQL Naming Conventions
on:
  pull_request:
    branches: [ master ]

jobs:
  sql_naming_check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Run SQL Naming Convention Check
        uses: ./.github/actions/sql_naming_check
        with:
          base-branch: 'master'
          compare-branch: 'feature/my-changes'
      
      - name: Print Validation Result
        run: |
          echo "Decoded validation-result:"
          echo "${{ fromBase64(steps.sql_naming_check.outputs.validation-result) }}"
```

### Interpreting the Results

- If violations are detected, the `validation-result` output will contain them in base64-encoded form. You can decode it in a subsequent step using `fromBase64()` if you want human-readable output.
  
- If no violations occur, `validation-result` will be empty.

## Examples of Valid and Invalid File Names

**Valid:**
- `[MIGRATION]_create_users_table.sql`
- `[ROLLBACK]_remove_outdated_index.sql`
- `[SCRIPT]_populate_initial_data.sql`

**Invalid:**
- `create_users_table.sql` (missing prefix)
- `[MIGRATION]_.sql` (prefix present but no descriptive name)
- `MIGRATION_create_users_table.sql` (prefix not properly enclosed in square brackets)

## Troubleshooting

- **No Changed SQL Files:**  
  If no `.sql` files have changed between the specified branches, the action exits without producing violations. This is a normal scenario if no SQL changes are introduced.
  
- **Incorrect Branch Names:**  
  Ensure that `base-branch` and `compare-branch` exist in your repository. If the action fails to fetch branches, verify that the branches are spelled correctly and that your repository is accessible.

- **Adjusting Exit Behavior:**  
  By default, the action does not fail the workflow if violations are found. If you require the workflow to fail on violations, you can add a subsequent step that checks the `validation-result` output and exits non-zero if it’s not empty.