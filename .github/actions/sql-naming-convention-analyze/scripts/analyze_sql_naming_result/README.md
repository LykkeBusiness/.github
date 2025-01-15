# analyze_sql_naming_result.sh

This script decodes a base64-encoded validation result string and analyzes its contents to determine if SQL naming convention violations have been found. If violations are detected, it prints them to the console and exits with a non-zero status code to signal a failure in the workflow.

## What It Does

1. **Decoding Results**:  
   The script takes a single argument (a base64-encoded string) and decodes it back into a readable format.

2. **Violation Detection**:  
   - If the decoded string is empty, it means no violations were detected, and the script exits with a zero status code.
   - If the decoded string is non-empty, it indicates that violations exist. The script prints the violations, one per line, and then exits with a non-zero status code.

## Usage

```bash
./analyze_sql_naming_result.sh <BASE64_ENCODED_STRING>
```

**Parameters:**

- `<BASE64_ENCODED_STRING>`:  
  A base64-encoded string containing the validation results (e.g., one or more lines detailing SQL naming convention violations).

## Examples

**No Violations:**

```bash
./analyze_sql_naming_result.sh ""
```

- Since the input is empty, the script exits normally with `exit 0`, producing no output.

**With Violations:**

```bash
BASE64_RESULT=$(echo "file1.sql: Missing prefix" | base64 -w0)
./analyze_sql_naming_result.sh "$BASE64_RESULT"
```

**Output:**
```
SQL Naming Convention Violations:
- file1.sql: Missing prefix
```

The script then exits with a non-zero status code (e.g., `exit 1`), indicating to any calling process (such as a GitHub Actions workflow) that violations were found.

## Exit Codes

- **0**: No violations detected.
- **Non-Zero**: Violations detected.

This enables CI/CD pipelines to fail automatically if naming conventions are not adhered to.