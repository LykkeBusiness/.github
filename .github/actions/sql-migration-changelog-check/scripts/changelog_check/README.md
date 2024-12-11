# changelog_check.sh

This script validates that every `[MIGRATION]` or `[ROLLBACK]`-prefixed SQL file listed in a specified file is referenced in a `CHANGELOG.md` file within the provided (or current) directory. Specifically:

- A `[MIGRATION]`-prefixed file is expected to have a corresponding entry in the CHANGELOG matching the exact line:  
  ```plain
  ### Migration: <<<filename>>> [MANUAL]
  ```
  
- A `[ROLLBACK]`-prefixed file is expected to have a corresponding entry matching the exact line:  
  ```plain
  ### Rollback: <<<filename>>>
  ```

Any file that does not meet these conditions is reported as invalid.

## Usage

```bash
./changelog_check.sh <migration_scripts_list> [search_dir]
```

**Parameters:**

- `<migration_scripts_list>`: A file containing a list of paths to SQL files (either `[MIGRATION]_...sql` or `[ROLLBACK]_...sql`), one per line.  
- `[search_dir]` *(optional)*: The directory to search for `CHANGELOG.md`. Defaults to the current directory (`.`).

## What It Does

1. **Input Validation**:  
   - The script requires one or two arguments:
     - If fewer than one or more than two arguments are provided, the script prints a usage message and exits with code **1**.
   - It checks whether the given `<migration_scripts_list>` file exists:
     - If it does not, the script prints an error message and exits with code **1**.

2. **Locating CHANGELOG.md**:  
   - The script attempts to locate a `CHANGELOG.md` file within the specified `[search_dir]` (or the current directory if `[search_dir]` is not provided).
   - If no `CHANGELOG.md` file is found, the script prints an error message and exits with code **0**.

3. **Verifying CHANGELOG Entries**:  
   - For each file path in `<migration_scripts_list>`:
     1. If the file name (basename) starts with `[MIGRATION]`, the script looks for a matching line in `CHANGELOG.md`:
        ```plain
        ### Migration: <<<filename>>> [MANUAL]
        ```
        If this line is not found, the file is flagged as invalid.
     2. If the file name starts with `[ROLLBACK]`, the script looks for a matching line:
        ```plain
        ### Rollback: <<<filename>>>
        ```
        If this line is not found, the file is flagged as invalid.
     3. If the file name does not start with `[MIGRATION]` or `[ROLLBACK]`, the script flags it as invalid.
   
   - As it processes each file, any invalid entries are tracked in an internal list.

4. **Reporting Invalid Files**:  
   - After processing all entries, if any files are marked invalid, their paths are printed, one per line.
   - If no invalid files are found, the script produces no output.

## Exit Codes

- **0**:  
  Successful execution (indicates the script ran, but not necessarily that no invalid files were found).  
  Note that the script returns **0** if `CHANGELOG.md` is missing (since it's not considered a runtime error but an absence of a reference file).
- **1**:  
  Invalid usage (wrong number of arguments) or the `<migration_scripts_list>` file does not exist.

## Dependencies

- **File Input**:  
  The file passed as an argument (e.g., `migration_scripts.txt`) must contain a list of `[MIGRATION]` or `[ROLLBACK]` SQL files, one per line.
- **Environment**:  
  This script uses `find`, `grep`, and `basename`, which are standard Unix tools available in most POSIX-compliant environments.

## Example

```bash
# Assuming migration_scripts.txt contains:
# ./migrations/[MIGRATION]_create_users_table.sql
# ./migrations/[ROLLBACK]_create_users_table.sql
# ./migrations/[MIGRATION]_create_products_table.sql

./changelog_check.sh migration_scripts.txt ./migrations
```

- The script searches `./migrations` for a `CHANGELOG.md` file.
- For each file listed in `migration_scripts.txt`:
  - `[MIGRATION]` files must have a corresponding `### Migration: <<<[MIGRATION]_filename>>> [MANUAL]` entry in `CHANGELOG.md`.
  - `[ROLLBACK]` files must have a corresponding `### Rollback: <<<[ROLLBACK]_filename>>>` entry in `CHANGELOG.md`.
- The script prints any file paths that do not meet these requirements.

## Notes

- The script uses `set -Eeuo pipefail` to enforce strict error handling.
- The script does **not** create or modify any files; it only reads the provided input file and `CHANGELOG.md`.
- If you'd like the build or CI job to fail when invalid files are detected, you can check the script’s output or adjust its exit code handling to better suit your CI/CD workflow.