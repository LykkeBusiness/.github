# SQL Policy Reusable Workflow

This reusable GitHub Actions workflow, named `sql-policy`, serves as a central orchestrator that utilizes sub-workflows to validate SQL file naming conventions, ensure parity between SQL migrations and their corresponding rollbacks, **and verify the presence of required SQL migration changelog entries.** By leveraging reusable workflows, the codebase becomes modular and maintainable, allowing for easier updates and extensions.

## What It Does

1. **Branch Comparison**  
   Takes a base branch (default: `master`) and a comparison branch, then checks for changes between them.

2. **Reusable Workflows Integration**  
   The `sql-policy` workflow calls several sub-workflows to perform specific checks:
   - **SQL Naming Convention Validation**  
     Invokes the `sql-naming-check.yml` workflow to ensure all changed SQL files follow specific naming conventions. This helps maintain consistency and clarity in your SQL migrations, rollbacks, and scripts.
   - **SQL Migration-Rollback Parity Check**  
     Calls the `sql-migration-rollback-parity-check.yml` workflow to ensure every SQL migration file has a corresponding rollback file where needed, maintaining strict parity. This step helps ensure that database changes can always be reversed if necessary.
   - **EF Core Migration-Rollback Parity Check**  
     Uses the `sql-ef-migration-rollback-parity-check.yml` workflow to verify that every EF Core migration has a corresponding rollback. This ensures that code-first migrations are reversible, maintaining the integrity of your database schema over time.
   - **SQL Changelog Check**  
     Adds a final layer of verification via the `sql-changelog-check.yml` workflow. This step checks whether the relevant SQL migrations are properly documented in the `CHANGELOG.md`, ensuring that changes are recorded for auditing and tracking purposes.

## Future Improvements

This workflow is designed with extensibility in mind. While it currently focuses on SQL file naming conventions, migration-rollback parity, and a changelog check, future enhancements might include:

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
  run_sql_policy_check:
    uses: .github/workflows/sql-policy.yml@master
    with:
      base_branch: ${{ github.base_ref }}
      compare_branch: ${{ github.head_ref }}
```

In the above example, each pull request targeting `master` will trigger the `sql-policy` workflow, which in turn invokes the reusable sub-workflows for various SQL checks. Violations will be printed out, and the job will fail if any issues are detected. This includes naming convention violations, migration-rollback parity issues, and any missing or incomplete migration changelog entries—helping maintain a robust and consistent database schema workflow.