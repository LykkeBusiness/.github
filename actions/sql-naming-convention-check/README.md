# SQL Naming Convention Check Action

Validates the naming conventions of SQL files in a pull request by comparing changes between a base branch and a compare branch. This action ensures all SQL files follow predefined naming rules.

## Prerequisites
Is is expected action will be executed in a context of git repository.

## Naming Conventions

- **Migration Scripts:** Must start with the prefix `[MIGRATION]_`.
- **Rollback Scripts:** Must start with the prefix `[ROLLBACK]_`.
- **Other SQL Scripts:** Must start with the prefix `[SCRIPT]_`.
- **Prohibited:** File names like `[MIGRATION]_.sql` or `[SCRIPT]_.sql` (prefix without a specific name) are not allowed.

## Inputs

#### `base-branch`
**Description**: Name of the base branch for comparison.
**Required**: Yes

#### `compare-branch`
**Description**: Name of the branch to compare against the base branch.
**Required**: Yes

## Outputs

#### `validation-result`
**Description**: Result of the validation check.

## Example Usage

```yaml
uses: ./.github/actions/sql-naming-convention-check@v1
with:
  base-branch: 'main'
  compare-branch: 'feature-branch'
```

## Notes

This action runs a validation script that:
1. Extracts `.sql` files from the diff between the specified branches.
2. Checks each file name against the rules.
3. Reports any files that do not follow the conventions along with the specific rule violated.

### Example File Names

- ✅ `[MIGRATION]_add_new_table.sql`
- ✅ `[ROLLBACK]_remove_column.sql`
- ✅ `[SCRIPT]_data_update.sql`
- ❌ `[MIGRATION]_.sql` (missing specific name)
- ❌ `data_script.sql` (missing required prefix)

Ensure your SQL files follow the conventions to pass this check.

