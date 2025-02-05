# Deprecated NuGet Packages Check

This GitHub Action checks for deprecated NuGet packages in your .NET projects. It lists deprecated packages fails the workflow if they are detected, unless they are explicitly excluded.

## Inputs

- `path` (required): Relative path to the folder containing the `.sln` (solution) file or a single `.csproj` project.
- `excluded-packages`: A comma-separated list of package names to exclude from the deprecated check.

> **Note:** This action requires .NET to be installed on the runner. Make sure to add a step like `actions/setup-dotnet` if needed.


## Usage Example

Below is an example of how you might use this action in a workflow. It assumes your `.NET` solution is located in the `./src` folder, and you want to exclude package `Microsoft.Rest.ClientRuntime`:

```yaml
name: CI

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  nuget-vulnerability-check:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Set up .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.0.x'

      - name: Run NuGet Vulnerability Check
        uses: ./.github/actions/deprecated-packages-check
        with:
          path: './src'
          excluded-packages: 'Microsoft.Rest.ClientRuntime'
```

## Notes
- By default, no packages are excluded. If you specify multiple packages, separate them with commas (no spaces).
- Make sure the path input is correctly pointing to your .sln or .csproj file. If you have multiple projects, you might need multiple steps or workflows.
