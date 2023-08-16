# Extract Release Notes Action

Extracts the latest release name and release notes from a `CHANGELOG.md` file. If a release name isn't present, one can be automatically generated.

The priority for the release name is as follows:
- `release_name` input
- Release name extracted from `CHANGELOG.md`
- Generated release name if `auto_name_release` is `true`. In this case `version` must be provided since it is used to generate the release name.

## Inputs

#### `auto_name_release`
**Description**: Automatically name the release if a release name isn't provided and it isn't present in `CHANGELOG.md`.  
**Required**: Yes  
**Type**: Boolean  
**Default**: `false`

#### `release_name`
**Description**: A release name that takes precedence over the release name extracted from `CHANGELOG.md`.  
**Required**: No

#### `folder`
**Description**: Folder to search for `CHANGELOG.md` files.  
**Required**: No  
**Default**: `.` (current directory)

#### `version`
**Description**: Version number without "v" (e.g. `1.0.0`). Used to generate a release name if not present in `CHANGELOG.md`.  
**Required**: No

## Outputs

#### `RELEASE_NAME`
The extracted or generated release name.

#### `RELEASE_NOTES_FILE`
Path to a text file containing the extracted release notes.

## Example Usage

```yaml
uses: your-org/your-repo@version
with:
  release_name: 'My Special Release'
  folder: './path/to/search'
```

## Note

Ensure your CHANGELOG.md adheres to the specific format:

```markdown
## [Version] - [Release Name] (YYYY-MM-DD)
```

e.g.
    
```markdown
## 1.0.0 - Initial Release (2020-01-01)
```
