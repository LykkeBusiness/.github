# find_ef_migration_files.sh

This script compares two Git branches (a base branch and a compare branch) to identify Entity Framework Core migration `.cs` files and SQL rollback `.sql` files that match specific naming patterns. It then writes the names of these changed files to `ef_migration_files.txt`. If no matching files are found, the script exits successfully without creating or modifying `ef_migration_files.txt`.

## Usage

```bash
./find_ef_migration_files.sh [BASE_BRANCH] [COMPARE_BRANCH]
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
   The script performs two separate comparisons:
   
   - **Entity Framework Core Migration Files**  
     It first searches for changed C# migration files in the `Migrations/` directory that follow a specific pattern: a 14-digit timestamp followed by an underscore and filename, ending with `.cs`. It excludes files ending with `Designer.cs`. This is achieved with:
     ```bash
     git diff --name-only "origin/${BASE_BRANCH}...origin/${COMPARE_BRANCH}" |
         grep -E 'Migrations/[0-9]{14}_.+\.cs$' |
         grep -v 'Designer\.cs$'
     ```
   
   - **SQL Rollback Files**  
     It then looks for changed SQL rollback files that start with `[ROLLBACK]_` and end with `.sql` using:
     ```bash
     git diff --name-only "origin/${BASE_BRANCH}...origin/${COMPARE_BRANCH}" |
         grep -E '\[ROLLBACK\]_.+\.sql$'
     ```

   Both sets of files are appended to the `CHANGED_FILES` array for further processing.

3. **Output Results**  
   - If matching files are found, their paths are written to `ef_migration_files.txt`, one per line.
   - If no matching files are found, the script prints a message indicating no relevant changes and exits with code `0`.

## Exit Codes

- **0**: Successful execution. Even if no matching files are found, the script still exits with this code to indicate normal completion.

## Example

```bash
./find_ef_migration_files.sh main feature/new-migrations
```

- Fetches the `main` and `feature/new-migrations` branches from `origin`.
- Lists changed files between the two branches.
- Filters for:
  - EF Core migration `.cs` files in the `Migrations/` directory that match the pattern `[timestamp]_*.cs` but are not designer files.
  - SQL rollback `.sql` files that match `[ROLLBACK]_*.sql`.
- Writes the names of those files into `ef_migration_files.txt`.
- If none are found, displays a message and exits without an error.

## Notes

- This script uses `set -Eeuo pipefail` to enforce strict error handling.
- If no matching migration or rollback files are found, no output file is created or modified, and the script exits successfully.
- You must have a functioning Git setup and the necessary permissions to execute the script.