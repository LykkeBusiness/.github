# EF Core Migration-Rollback Parity Check GitHub Action

This GitHub Action ensures that for every EF Core migration file detected, there is a corresponding rollback script. By running this check, you can enforce parity between your EF Core migrations and their reversals, helping maintain consistency and the ability to revert changes in your database schema.

## Features

- **Automated Detection of EF Core Migration Files:**  
  Identifies EF Core migration files within your codebase by comparing two branches.
  
- **Rollback Parity Validation:**  
  For each detected EF Core migration, this action checks whether a corresponding rollback script is present. Migrations without matching rollbacks are flagged.
  
- **Action Outputs:**  
  Returns a base64-encoded string listing any EF Core migrations lacking rollbacks. If there are no violations, this output remains empty.

## Inputs

- `base-branch` (required, default: `"master"`):  
  The base branch against which differences are checked. Usually, this is your main branch (e.g., `master` or `main`).

- `compare-branch` (required):  
  The branch you want to compare with the base branch. This should be the feature or development branch containing new EF Core migrations.

## Outputs

- `validation-result`:  
  A base64-encoded string listing all EF Core migration files that do not have corresponding rollback scripts. If no mismatches are detected, this output will be empty.

## Usage

Here is an example workflow configuration snippet that uses this action:

```yaml
name: Validate EF Core Migration-Rollback Parity
on:
  pull_request:
    branches: [ master ]

jobs:
  ef_core_parity_check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Run EF Core Migration-Rollback Parity Check
        uses: ./.github/actions/ef_core_migration_rollback_parity_check
        with:
          base-branch: 'master'
          compare-branch: ${{ github.head_ref }}

      - name: Print Validation Result
        run: |
          echo "Decoded validation-result:"
          echo "${{ fromBase64(steps.ef_core_parity_check.outputs.validation-result) }}"
```

### Interpreting the Results

- If any EF Core migration files are missing corresponding rollback scripts, `validation-result` will contain their filenames in base64-encoded form. You can decode the output using `fromBase64` or another method to review the human-readable filenames.
- If every EF Core migration has a corresponding rollback script, `validation-result` will be empty.

## Examples

**Scenario:**
- EF Core Migration Files Detected:  
  - `20230101120115_AddNewTable.cs`
  - `20230102131011_AddNewColumn.cs`
  
- Corresponding Rollback Scripts Found:  
  - `[ROLLBACK]_20230102131011_AddNewColumn.sql`
  
- Missing Rollback:  
  - For `20230101120115_AddNewTable.cs`, a corresponding `[ROLLBACK]_20230101120115_AddNewTable.sql` is not found.

**Violation:**
- `20230101120115_AddNewTable.cs` (no matching `[ROLLBACK]_20230101120115_AddNewTable.sql`)

## Troubleshooting

- **No EF Core Migration Files Found:**  
  If no EF Core migration files are detected (no changes compared to the base branch), the action reports no violations. This result is expected if there are no new or updated migrations.

- **Branch Name Issues:**  
  Verify that `base-branch` and `compare-branch` exist and are accessible. A mismatch in naming or insufficient repository permissions can cause the action to fail or miss files.

- **Failing the Workflow on Violations:**
  By default, this action will not fail the workflow if violations are detected. To fail on violations, you can add a subsequent step after decoding the `validation-result` output and exit with a non-zero code if violations are present.