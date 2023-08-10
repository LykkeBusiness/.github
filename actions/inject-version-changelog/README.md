# Inject New Version into CHANGELOG.md Action

This GitHub Action injects the new version into `CHANGELOG.md` by replacing a placeholder.

## Inputs

### `version`

**Required** The version number without the "v" prefix (e.g., `1.0.0`).

### `folder`

**Required** The folder to search for `CHANGELOG.md`. Defaults to `'.'`.

### `deployment_tools`

The folder with deployment tools. Defaults to `'./lykke.snow.deployment'`.

## Outputs

No explicit outputs. This action will fail the workflow if there are issues with the CHANGELOG.md file, such as finding multiple instances of the file, not finding the file, or failing to replace the placeholder.

## Example Usage

You can use this action in your workflow by including the following steps:

```yaml
- name: Inject Version into CHANGELOG.md
  uses: your-org/your-repo@version
  with:
    version: '1.2.3'
    folder: './path/to/changelog'
    deployment_tools: './path/to/deployment/tools'
```

Replace your-org/your-repo and version with the appropriate information for your action.

## Note
This action expects exactly one CHANGELOG.md file to be present in the specified folder and that file to contain a placeholder `'[[TBD]]'` or `'[[tbd]]'` for the new version. The placeholder will be replaced with the specified version. If these conditions are not met, the action will fail the workflow. 
Please adjust the paths and any specific instructions as needed.

