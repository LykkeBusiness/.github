# SQL Naming Convention Validation Script

This Bash script checks a list of SQL files to ensure that their filenames follow a specified naming convention. It validates whether each SQL file starts with one of the defined prefixes (`[MIGRATION]_`, `[ROLLBACK]_`, or `[SCRIPT]_`) and that there is a meaningful name following the prefix (i.e., not just the prefix and `.sql`).

## Features

- **Prefix Validation:** Ensures each file name starts with a valid prefix.
- **Naming Check:** Verifies that the file name following the prefix is not empty.

## Requirements

- **Bash Shell:** The script is POSIX-compliant and tested in Bash environments.
- **GitHub Actions (Optional):** Can be used within CI workflows for automated checks.

## Usage

1. Prepare a text file listing the SQL files you want to validate (one file path per line). For example:
   ```txt
   /path/to/changes/[MIGRATION]_add_users_table.sql
   /path/to/changes/[ROLLBACK]_remove_orders_table.sql
   /path/to/changes/[SCRIPT]_populate_data.sql
   ```

2. Run the script:
   ```bash
   ./validate_sql_naming.sh sql_files_list.txt
   ```

3. If all files comply with the naming convention, the script will produce no output and exit with status 0. If any files fail the checks, it will print the violations and exit with status 0 (non-zero exit codes can be incorporated as needed).

## Exit Codes

- **0:** Script executed successfully.  
  - **Note:** Even if some files fail the checks, the script still exits with 0 by default. You can modify the script to exit with a non-zero code if naming violations occur.
- **1:** Script encountered an error (e.g., missing input file, invalid file paths).

## Examples

**Valid Files:**
- `[MIGRATION]_create_users_table.sql`
- `[ROLLBACK]_remove_users_index.sql`
- `[SCRIPT]_update_data_for_reporting.sql`

**Invalid Files:**
- `create_users_table.sql` (missing prefix)
- `[MIGRATION]_.sql` (missing descriptive name after prefix)
- `MIGRATION_create_users_table.sql` (incorrect format, missing brackets around prefix)