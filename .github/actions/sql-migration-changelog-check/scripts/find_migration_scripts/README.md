# check_changed_migration_scripts.sh

This script compares two Git branches (a base branch and a compare branch) to identify `.sql` files that match specific naming patterns for migrations or rollbacks. It then writes the names of these changed files to `migration_scripts.txt`. If no matching files are found, the script exits successfully without creating or modifying `migration_scripts.txt`.

## Usage

```bash
./check_changed_migration_scripts.sh [BASE_BRANCH] [COMPARE_BRANCH]
```

**Parameters:**

- `BASE_BRANCH`: The name of the base branch to compare from.
- `COMPARE_BRANCH`: The name of the compare branch that introduces changes.

## Description

1. **Fetch Remote Branches**  
   The script begins by fetching both the base and compare branches from the remote repository:
   ```bash
   git fetch origin "${BASE_BRANCH}" "${COMPARE_BRANCH}"
   ```

2. **Compare Changed Files**  
   Next, it runs:
   ```bash
   git diff --name-only "origin/${BASE_BRANCH}...origin/${COMPARE_BRANCH}"
   ```
   to list all file changes introduced between the two branches.  
   It then filters those results to identify any `.sql` files whose names contain `[MIGRATION]` or `[ROLLBACK]` at the beginning (e.g., `[MIGRATION]_filename.sql` or `[ROLLBACK]_filename.sql`) using:
   ```bash
   grep -E '\[(MIGRATION|ROLLBACK)\]_.+\.sql$'
   ```

3. **Output Results**  
   - If matching files are found, they are written to `migration_scripts.txt`, one per line.  
   - If no matching files are found, the script prints a message indicating no changes and exits with code `0`.

## Exit Codes

- **0**: Successful execution. Even if no matching files are found, the script still exits with this code to indicate normal completion.

## Example

```bash
./check_changed_migration_scripts.sh main feature/new-migrations
```

- Fetches the `main` and `feature/new-migrations` branches from `origin`.
- Lists changed files between the two branches.
- Filters for `.sql` files that match `[MIGRATION]_.sql` or `[ROLLBACK]_.sql`.
- Writes the names of those files into `migration_scripts.txt`.
- If none are found, displays a message and exits without an error.

## Notes

- This script uses `set -Eeuo pipefail` to enforce strict error handling.
- If `git diff` returns no matching files, no output file is created or modified, and the script exits successfully.
- You must have a functioning Git setup and the necessary permissions to execute the script.