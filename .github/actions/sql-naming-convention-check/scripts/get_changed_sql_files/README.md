# get_changed_sql_files.sh

This script identifies all `.sql` files changed between two specified Git branches and writes their paths to `sql_files.txt`. If no `.sql` files have been modified, the script exits without producing output.

## Usage

```bash
./get_changed_sql_files.sh <BASE_BRANCH> <COMPARE_BRANCH>
```

**Parameters:**

- `BASE_BRANCH`: The branch you want to compare against (e.g. `master`).
- `COMPARE_BRANCH`: The branch you want to compare to the base branch (e.g. `feature/new-changes`).

## Description

1. **Fetch Branches**  
   The script begins by fetching the specified base and compare branches from `origin` to ensure they are up-to-date locally.
   
2. **Identify Changed SQL Files**  
   Using `git diff`, the script calculates differences between the two branches. It then filters the result for `.sql` files.  
   
   Specifically, it runs:
   ```bash
   git diff --name-only "origin/${BASE_BRANCH}...origin/${COMPARE_BRANCH}"
   ```
   This outputs a list of files changed between the two branches. The script then uses `grep -E '\.sql$'` to extract only files that end with `.sql`.
   
3. **Output Results**  
   - If any `.sql` files have changed, their names are written to `sql_files.txt`, one per line.
   - If no `.sql` files are found, the script exits without creating or modifying `sql_files.txt`.

## Exit Codes

- **0**: Successful execution. No errors occurred. If no `.sql` files are found, the script still exits with code `0` as it is considered a normal scenario.
  
## Example

```bash
./get_changed_sql_files.sh master feature/my-sql-changes
```

- Fetches `master` and `feature/my-sql-changes` branches.
- Outputs the list of changed `.sql` files between `master` and `feature/my-sql-changes` into `sql_files.txt`.
- If no `.sql` files changed, the script does nothing further and exits cleanly.

## Notes

- This script uses `set -Eeuo pipefail` to ensure strict error handling.
- If `git diff` or `grep` produce no results, the script safely handles this by using `|| true` to prevent the pipeline from failing.
- Make sure you have a valid Git repository and the necessary branches accessible when running this script.