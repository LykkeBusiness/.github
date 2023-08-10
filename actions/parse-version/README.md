# Parse Version Number Action

This action parses a version string, removing any preceding "v", and sets it as an environment variable.

## Inputs

### `version`

**Required** The version string to be parsed (e.g., "v1.0.0").

## Outputs

No direct outputs. The parsed version number (without the preceding "v") will be set as an environment variable `TAG_NUMBERS`.

## Example Usage

You can use this action in your workflow file as follows:

```yaml
jobs:
  example-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Parse Version Number
        uses: ./.github/actions/parse-version
        with:
          version: ${{ github.event.inputs.version }}

      - run: echo "Parsed version number is $TAG_NUMBERS"
```
