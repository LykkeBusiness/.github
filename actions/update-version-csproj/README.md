# Update .csproj Files with the New Version Action

This GitHub Action updates all `.csproj` files with the specified new version.

## Inputs

### `version`

**Required** The version number without the "v" prefix (e.g., `1.0.0`).

### `folder`

The folder to search for `.csproj` files. Defaults to `'.'`.

### `deployment_tools`

The folder with deployment tools. Defaults to `'./lykke.snow.deployment'`.

## Outputs

No explicit outputs. This action will fail the workflow if no `.csproj` files are found or if there is an issue with updating the version in any of the found files.

## Example Usage

You can use this action in your workflow by including the following steps:

```yaml
- name: Update .csproj Files with New Version
  uses: your-org/your-repo@version
  with:
    version: '1.2.3'
    folder: './path/to/csproj/files'
    deployment_tools: './path/to/deployment/tools'
```
Replace your-org/your-repo and version with the appropriate information for your action.

## Note

This action expects to find one or more `.csproj`` files in the specified folder and will update the version information in each file with the specified version. If no .csproj files are found or there is an issue with updating the version in any file, the action will fail the workflow.
Feel free to modify the paths and other details as needed for your specific use case.
