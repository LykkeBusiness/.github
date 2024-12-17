# SQL Check Reusable Workflow

This reusable GitHub Actions workflow provides a baseline for validating SQL file naming conventions and ensuring parity between SQL migrations and their corresponding rollbacks. As your codebase evolves, this workflow can be extended to include additional checks, ensuring that all database-related changes meet defined quality and consistency standards before they are merged.

## What It Does

1. **Branch Comparison**:  
   Takes a base branch (default: `master`) and a comparison branch, then checks for changes between them.

2. **SQL Naming Convention Validation**:  
   Runs a dedicated action to ensure all changed SQL files follow specific naming conventions. This helps maintain consistency and clarity in your SQL migrations, rollbacks, and scripts.

3. **Result Analysis (Naming Conventions)**:  
   Decodes and analyzes the output of the naming convention check. If any violations are found, the workflow fails, preventing non-compliant changes from moving forward.

4. **SQL Migration-Rollback Parity Check**:  
   Performs an additional validation to ensure that every migration file has a corresponding rollback file where needed, maintaining strict parity. This step helps ensure that database changes can always be reversed if necessary.

5. **Result Analysis (Migration-Rollback Parity)**:  
   Examines the results of the migration-rollback parity check. If any parity issues are detected (e.g., a migration without a proper rollback), the workflow fails, signaling that the database change is incomplete or out of compliance.

## Future Improvements

This workflow is designed with extensibility in mind. While it currently focuses on SQL file naming conventions and migration-rollback parity, future enhancements might include:

- **SQL Syntax Checks**: Incorporate linting tools to detect syntax errors or potential issues in SQL code.
- **Migration Testing**: Ensure that migrations can be applied and rolled back successfully in test environments.
- **Policy Enforcement**: Check for certain keywords, patterns, or security requirements in SQL files.

By gradually adding more checks, you can transform this workflow into a comprehensive SQL quality gate, integrating seamlessly into your CI/CD pipeline and automatically enforcing best practices.

## Usage

This workflow can be called from other workflows using `workflow_call` triggers. You can also trigger it manually via `workflow_dispatch` for testing or on-demand validation. Simply specify the base and compare branches as inputs, and the workflow handles the rest.

**Example:**

```yaml
name: On Pull Request
on:
  pull_request:
    branches: [ master ]

jobs:
  run_sql_check:
    uses: .github/workflows/sql-check.yml@master
    with:
      base_branch: ${{ github.base_ref }}
      compare_branch: ${{ github.head_ref }}
```

In the above example, each pull request targeting `master` will trigger all the SQL checks defined in this reusable workflow. Violations will be printed out, and the job will fail if any issues are detected. This includes both naming convention violations and migration-rollback parity issues, helping maintain a robust and consistent database schema workflow.