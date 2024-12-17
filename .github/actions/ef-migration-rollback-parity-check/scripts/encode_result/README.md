# encode_result.sh

This script reads a given results file (e.g., containing validation errors) and base64-encodes its contents. It then prints the encoded string as a `validation-result` key-value pair suitable for consumption in GitHub Actions workflows.

## Usage

```bash
./encode_result.sh <RESULT_FILE>
```

**Parameters:**

- `RESULT_FILE`: The file containing validation results (e.g., a list of naming convention violations). This file is expected to be non-empty if there are violations.

## Behavior

1. **Check the File**:  
   The script verifies if the specified file (`RESULT_FILE`) exists and is not empty.

2. **Encoding**:  
   - If the file is non-empty, its contents are base64-encoded and assigned to the `validation-result` output.
   - If the file is empty or does not exist, `validation-result` is set to an empty string.

3. **Output**:
   The script prints the output in a format that can be used with GitHub Actions:
   ```bash
   validation-result=<base64_encoded_string>
   ```

## Exit Codes

- **0**: The script ran successfully and printed the `validation-result` line.
- **Non-Zero**: An error occurred while running the script, such as providing an invalid file path or lacking necessary permissions.

## Example

```bash
# If 'validation_result.txt' contains some violations:
./encode_result.sh validation_result.txt
# Outputs something like:
# validation-result=QmFzZTY0IEVuY29kZWQgUmVzdWx0cw==
```

If `validation_result.txt` is empty, the script prints:
```
validation-result=
```