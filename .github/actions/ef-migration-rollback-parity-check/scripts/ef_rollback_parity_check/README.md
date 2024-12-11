# ef_rollback_parity_check.sh

This script verifies that for every Entity Framework (EF) migration file listed in the provided input file, there is a corresponding rollback SQL script in the project. It ensures that for each `<timestamp>_<migration-name>.cs` file, a `[ROLLBACK]_<timestamp>_<migration-name>.sql` file exists.

## Usage

```bash
./ef_rollback_parity_check.sh <ef_migration_files.txt>
```

**Parameters:**

- `<ef_migration_files.txt>`: A file containing a list of paths to EF migration `.cs` files, one per line. `.Designer.cs` files have to be excluded from the list, otherwise, the script will not work correctly.

## What It Does

1. **Input Validation**:  
   The script takes exactly one argument:
   - If no argument is provided, it prints a usage message and exits with a non-zero code.
   - If the provided file does not exist, the script prints an error message and exits with a non-zero code.

2. **Checking for Rollback Parity**:  
   For each EF migration file in the provided input:
   - It extracts the base migration name by removing the `.cs` extension.
     - Example: For `20240101093000_AddUsers.cs`, the `migration_name` is `20240101093000_AddUsers`.
   - It then searches the current directory (and all subdirectories) for a corresponding rollback file named `[ROLLBACK]_<migration_name>.sql`.
   
   If no matching rollback file is found, that migration file is added to a list of "invalid" files.

3. **Reporting Missing Rollbacks**:  
   - After processing all entries, if any invalid files are found (i.e., those without corresponding rollback scripts), the script prints their paths, one per line.
   - If all migration files have matching rollback scripts, the script produces no output.
   - The script exits with code **0** regardless of whether invalid files are found.

## Exit Codes

- **0**: Successful execution (indicates the script ran without encountering argument or file errors; it does not imply that no invalid files were found).
- **1**: Invalid usage or missing input file.

## Dependencies

- **File Input**:  
  The input file (e.g., `ef_migration_files.txt`) should list EF migration `.cs` files, one per line.

- **Environment**:  
  The script uses standard Unix tools like `find` and `basename`.

## Example

**Input File (ef_migration_files.txt):**

```
./migrations/20240101093000_AddUsers.cs
./migrations/20240101100000_ModifyUsers.cs
```

**Running the Script:**

```bash
./ef_rollback_parity_check.sh ef_migration_files.txt
```

- For each `./migrations/<timestamp>_<migration-name>.cs` file, the script looks for `[ROLLBACK]_<timestamp>_<migration-name>.sql`.
- If any corresponding rollback file is missing, the path to the `.cs` file is printed.
- If all have corresponding rollback files, nothing is printed.

## Notes

- The script uses `set -Eeuo pipefail` to enforce strict error handling.
- The script does not modify or create any files; it only checks for missing rollback scripts.
- Use subsequent steps in your CI/CD pipeline to handle the output, such as failing the build if any invalid files are found.