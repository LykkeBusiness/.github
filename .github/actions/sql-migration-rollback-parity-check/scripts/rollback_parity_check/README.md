# rollback_parity_check.sh

This script checks for the existence of corresponding rollback scripts for each migration script listed in a specified file. It ensures that every `[MIGRATION]`-prefixed SQL file has a matching `[ROLLBACK]`-prefixed file with the same base name.

## Usage

```bash
./rollback_parity_check.sh <migration_scripts_list>
```

**Parameters:**

- `<migration_scripts_list>`: A file (e.g. `migration_scripts.txt`) containing a list of paths to `[MIGRATION]` SQL files, one per line.

## What It Does

1. **Input Validation**:  
   The script takes exactly one argument:
   - If no argument is provided, it prints a usage message and exits with a non-zero code.
   - If the provided file does not exist, the script prints an error message and exits with a non-zero code.

2. **Checking for Rollback Parity**:  
   For each migration script listed in `<migration_scripts_list>`:
   - The script extracts the base name of the migration script (everything after `[MIGRATION]_` and before `.sql`).
   - It then searches the current directory (and subdirectories) for a corresponding rollback script named `[ROLLBACK]_<migration_name>.sql`.
   
   If no matching rollback file is found, the script adds that migration file to a list of "invalid" files.

3. **Reporting Missing Rollbacks**:  
   - After processing all entries, if any invalid files are found (i.e., migration scripts without corresponding rollback scripts), the script prints their paths, one per line.
   - If no invalid files are found, the script produces no output.
   - The script exits with code `0` regardless of whether invalid files are found, allowing subsequent CI steps to handle the results as needed.

## Exit Codes

- **0**: Successful execution (indicates the script ran without errors, not necessarily that no invalid files were found).
- **1**: Invalid usage or missing input file.

## Dependencies

- **File Input**:  
  The file passed as an argument (e.g., `migration_scripts.txt`) must contain a list of `[MIGRATION]` SQL files, one per line.

- **Environment**:  
  This script uses `find` and `basename`, which are standard Unix tools available in most POSIX-compliant environments.

## Example

```bash
# Assuming migration_scripts.txt contains:
# ./migrations/[MIGRATION]_create_users_table.sql
# ./migrations/[MIGRATION]_alter_users_table.sql

./rollback_parity_check.sh migration_scripts.txt
```

- For each `./migrations/[MIGRATION]_...sql` file, the script attempts to find a corresponding `[ROLLBACK]_...sql` file.
- If any `[MIGRATION]` file lacks a corresponding `[ROLLBACK]` file, its path is printed.
- If all files have corresponding rollback scripts, the script produces no output.

## Notes

- The script uses `set -Eeuo pipefail` to enforce strict error handling.
- The script will not modify or create any files; it only reads the given input and prints missing rollback scripts if found.
- If you need different behavior (such as failing the build if missing rollbacks are detected), you can check the output of this script or use subsequent steps in your CI/CD pipeline to act upon the printed file paths.