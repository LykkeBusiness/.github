# find_ef_migration_files.sh

## Overview

`find_ef_migration_files.sh` is a Bash script designed for use within a CI/CD pipeline (e.g., GitHub Actions) to detect any new or changed [Entity Framework (EF) Core](https://docs.microsoft.com/ef/core/) migration files between two branches. EF Core migrations are code files that follow a specific naming convention, and this script helps identify when new migrations are introduced or modified.

## What Are EF Core Migration Files?

EF Core migrations are typically generated via the `dotnet ef migrations add` command. The resulting files:

- Are located in a directory named `Migrations` (or a subdirectory under it).
- Follow a naming pattern: `yyyyMMddHHmmss_<migration-name>.cs`, where `yyyyMMddHHmmss` is a 14-digit timestamp.
- The script excludes any `*.Designer.cs` files, which are associated but not considered the primary migration files.

**Example valid migration filename:** `20241217153000_AddCustomersTable.cs`  
**Example excluded designer file:** `20241217153000_AddCustomersTable.Designer.cs`

## How It Works

1. **Branch Comparison:** The script compares two Git branches, typically a base branch (e.g., `main`) and a feature branch (e.g., `feature/my-changes`).

2. **File Detection:** It runs `git diff` to find any files that differ between the two branches. It then filters this list to identify EF Core migration files that match the required pattern.

3. **Output:**  
   - If no EF Core migration files are detected, the script exits quietly with no output files.
   - If one or more migration files are found, it writes their paths to a `ef_migration_files.txt` file.

## Usage

### Prerequisites

- A POSIX-compliant shell (e.g., Bash) and `git` installed.
- Network access to fetch the branches from the remote origin (if not already available locally).

### Parameters

The script takes two parameters:

1. **BASE_BRANCH:** The name of the base branch (e.g., `main` or `master`).
2. **COMPARE_BRANCH:** The name of the feature branch or PR branch (e.g., `feature/my-new-migration`).

### Example

```bash
./find_ef_migration_files.sh main feature/my-new-migration
