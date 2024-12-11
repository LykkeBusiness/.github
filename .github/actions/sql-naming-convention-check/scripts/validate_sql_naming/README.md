# SQL Naming Convention Validation Script

This script validates that the names of SQL files adhere to a specified naming convention. It checks each file listed in a given text file and identifies any violations, such as missing required prefixes or lacking a descriptive name after the prefix.

## Naming Convention

Each SQL file must start with one of the following prefixes:

- `[MIGRATION]_`
- `[ROLLBACK]_`
- `[SCRIPT]_`

Additionally, the file name after the prefix must be meaningful. For instance:

- **Valid**: `[MIGRATION]_create_users_table.sql`
- **Invalid**: `[MIGRATION]_.sql` (no descriptive name after prefix)
- **Invalid**: `create_users_table.sql` (missing prefix)
- **Invalid**: `MIGRATION_create_users_table.sql` (prefix not enclosed in brackets)

## Usage

1. **Prepare the File List**  
   Create a text file that lists all SQL files to be checked, one file path per line. For example:
   ```txt
   /path/to/changes/[MIGRATION]_add_users_table.sql
   /path/to/changes/[ROLLBACK]_remove_orders_table.sql
   /path/to/changes/[SCRIPT]_populate_data.sql
   ```

2. **Run the Script**  
   Pass the file containing the list of SQL files as an argument to the script:
   ```bash
   ./validate_sql_naming.sh sql_files_list.txt
   ```

3. **Interpret the Results**  
   - If all files comply with the naming convention, the script produces no output and exits with status 0.
   - If any files violate the naming convention, the script prints each violation line-by-line. For example:
     ```
     /path/to/changes/create_users_table.sql: Does not start with a valid prefix ([MIGRATION]_, [ROLLBACK]_, or [SCRIPT]_).
     /path/to/changes/[MIGRATION]_.sql: Contains only the prefix without a specific name.
     ```
   
   By default, the script exits with status code 0 even if there are violations. You can modify the script if you want it to return a non-zero exit code when violations occur.

## Parameters

- **Required**:  
  - `sql_files_list.txt`: A file containing the paths of SQL files to validate, one file path per line.

## Exit Codes

- **0**: The script completed without encountering an error.  
  - Note: Violations in naming convention do **not** change the exit code by default; they only produce output. You can easily update the script to exit non-zero if violations are found.

- **1**: The script failed due to a usage error, such as an incorrect number of arguments or a missing input file.

## Example

```bash
# Assuming sql_files_list.txt contains the paths of SQL files.
./validate_sql_naming.sh sql_files_list.txt
```

- If violations exist, they are printed to stdout.
- If no violations are found, the script prints nothing and exits with status 0.