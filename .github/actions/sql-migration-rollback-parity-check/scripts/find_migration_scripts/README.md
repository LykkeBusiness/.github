# find_migration_scripts.sh

This script searches for `.sql` files that match a specific naming pattern (containing `[MIGRATION]`) within a specified directory and records the paths to `migration_scripts.txt`. If no matching `.sql` files are found, the script exits without producing output.

## Usage

```bash
./find_migration_scripts.sh [SEARCH_DIR]
```

**Parameters:**

- `SEARCH_DIR` (optional): The directory to search for matching `.sql` files. Defaults to the current directory (`.`) if not specified.

## Description

1. **Search for Migration Scripts**  
   The script uses the `find` command to look for all `.sql` files containing `[MIGRATION]` in their names within the specified `SEARCH_DIR`.  
   
   Specifically, it runs:
   ```bash
   find "$SEARCH_DIR" -type f -name "[MIGRATION]*.sql"
   ```
   
   This will return any files that begin with `[MIGRATION]` (or simply contain `[MIGRATION]` at the start of the filename) and end with `.sql`.

2. **Output Results**  
   - If any such `.sql` files are found, their paths are written to `migration_scripts.txt`, one per line.
   - If no matching `.sql` files are found, the script exits without creating or modifying `migration_scripts.txt`.

## Exit Codes

- **0**: Successful execution. No errors occurred. If no matching `.sql` files are found, the script still exits with code `0` as it is considered a normal scenario.

## Example

```bash
./find_migration_scripts.sh database/migrations
```

- Searches the `database/migrations` directory for `.sql` files whose names match `[MIGRATION]*.sql`.
- Outputs the list of such files into `migration_scripts.txt`.
- If none are found, the script silently exits without output.

## Notes

- This script uses `set -Eeuo pipefail` to ensure strict error handling.
- If `find` produces no results, the script safely exits without an error.
- Ensure you have the necessary permissions to run the script and access the specified search directory.