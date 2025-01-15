# changelog_ef_check.sh

This script validates that every `.cs` file (assumed to be an Entity Framework migration) or `[ROLLBACK]`-prefixed SQL file listed in a specified file is referenced in a `CHANGELOG.md` file within the provided (or current) directory. Specifically:

- A `.cs` file is expected to have a corresponding entry in the `CHANGELOG.md` matching the exact line:  
  ```plain
  ### Migration: <<<filename_without_extension>>> [AUTO]
  ```
  where `filename_without_extension` is the name of the `.cs` file without its `.cs` extension.

- A `[ROLLBACK]`-prefixed file is expected to have a corresponding entry matching the exact line:  
  ```plain
  ### Rollback: <<<filename>>>
  ```

Any file that does not meet these conditions is reported as invalid.

## Usage

```bash
./changelog_ef_check.sh <ef_migration_files.txt> [search_dir]
```

**Parameters:**

- `<ef_migration_files.txt>`: A file containing a list of paths to files, which can be either:
  - `.cs` files representing Entity Framework migrations, or
  - `[ROLLBACK]`-prefixed SQL files  
  Each file path should be on a separate line.

- `[search_dir]` *(optional)*: The directory to search for `CHANGELOG.md`. Defaults to the current directory (`.`).

## What It Does

1. **Input Validation**:  
   - The script requires one or two arguments:
     - If fewer than one or more than two arguments are provided, the script prints a usage message and exits with code **1**.
   - It checks whether the given `<ef_migration_files.txt>` file exists:
     - If it does not, the script prints an error message and exits with code **1**.

2. **Locating CHANGELOG.md**:  
   - The script attempts to locate a `CHANGELOG.md` file within the specified `[search_dir]` (or the current directory if `[search_dir]` is not provided).
   - If no `CHANGELOG.md` file is found, the script prints an error message and exits with code **0**.

3. **Verifying CHANGELOG Entries**:  
   - For each file path in `<ef_migration_files.txt>`:
     1. If the file name ends with `.cs`:
        - The script removes the `.cs` extension to get `filename_without_extension`.
        - It looks for a matching line in `CHANGELOG.md`:
          ```plain
          ### Migration: <<<filename_without_extension>>> [AUTO]
          ```
        - If this line is not found, the file is flagged as invalid.
        
     2. If the file name starts with `[ROLLBACK]`:
        - The script looks for a matching line in `CHANGELOG.md`:
          ```plain
          ### Rollback: <<<filename>>>
          ```
        - If this line is not found, the file is flagged as invalid.
        
     3. If the file does not match one of the above patterns (`.cs` or `[ROLLBACK]*`), the script flags it as invalid.
   
   - As it processes each file, any invalid entries are tracked in an internal list.

4. **Reporting Invalid Files**:  
   - After processing all entries, if any files are marked invalid, their paths are printed, one per line.
   - If no invalid files are found, the script produces no output.

## Exit Codes

- **0**:  
  Successful execution (indicates the script ran, but not necessarily that no invalid files were found).  
  Note that the script returns **0** if `CHANGELOG.md` is missing (since it's not considered a runtime error but an absence of a reference file).
  
- **1**:  
  Invalid usage (wrong number of arguments) or the `<ef_migration_files.txt>` file does not exist.

## Dependencies

- **File Input**:  
  The file passed as an argument (e.g., `ef_migration_files.txt`) must contain a list of `.cs` or `[ROLLBACK]` SQL files, one per line.
  
- **Environment**:  
  This script uses `find`, `grep`, and `basename`, which are standard Unix tools available in most POSIX-compliant environments.

## Example

```bash
# Assuming ef_migration_files.txt contains:
# ./migrations/20220222122212_CreateUsersTable.cs
# ./scripts/[ROLLBACK]_create_users_table.sql
# ./migrations/20221212121221_CreateProductsTable.cs

./changelog_ef_check.sh ef_migration_files.txt
```

- The script searches for a `CHANGELOG.md` file.
- For each file listed in `ef_migration_files.txt`:
  - `.cs` files must have a corresponding `### Migration: <<<FilenameWithoutExtension>>> [AUTO]` entry in `CHANGELOG.md`.
  - `[ROLLBACK]` files must have a corresponding `### Rollback: <<<[ROLLBACK]_filename>>>` entry in `CHANGELOG.md`.
- The script prints any file paths that do not meet these requirements.

## Notes

- The script uses `set -Eeuo pipefail` to enforce strict error handling.
- The script does **not** create or modify any files; it only reads the provided input file and `CHANGELOG.md`.