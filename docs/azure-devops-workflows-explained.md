# Azure DevOps Workflows - Complete Guide

This document explains each CI/CD workflow in detail, including what it does, when it runs, and how to configure it.

---

## Table of Contents

1. [CI Workflows (Pull Request / Push)](#ci-workflows)
   - [ci-sqlfluff.yml](#1-ci-sqlfluffyml---sql-linting-on-changed-files)
   - [ci-yamllint.yml](#2-ci-yamlllintyml---yaml-linting-on-changed-files)
   - [ci-python.yml](#3-ci-pythonyml---python-linting-on-changed-files)
   - [ci-secrets.yml](#4-ci-secretsyml---secrets-scanning)
   - [ci-gold-docs.yml](#5-ci-gold-docsyml---gold-layer-documentation-gate)
2. [CD Workflows (Deployment)](#cd-workflows)
   - [cd-snowflake-perms.yml](#6-cd-snowflake-permsyml---snowflake-permissions)
3. [Nightly Workflows (Scheduled)](#nightly-workflows)
   - [nightly-sqlfluff.yml](#7-nightly-sqlfluffyml---full-sql-lint)
   - [nightly-yamllint.yml](#8-nightly-yamlllintyml---full-yaml-lint)
   - [nightly-python.yml](#9-nightly-pythonyml---full-python-lint--tests)
4. [Required Setup](#required-setup)

---

## CI Workflows

These workflows run on **every pull request** and **push** to validate code quality before merging.

---

### 1. `ci-sqlfluff.yml` - SQL Linting on Changed Files

**Purpose:** Lint only the SQL files that were changed in a PR/commit using SQLFluff with the dbt templater.

**When it runs:**
- On every push to any branch
- On every pull request

**What it does:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     ci-sqlfluff.yml                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Checkout Repository                                          │
│     └── Full git history (fetchDepth: 0) for diff comparison    │
│                                                                  │
│  2. Install Python 3.11                                          │
│                                                                  │
│  3. Install Dependencies                                         │
│     ├── dbt-core==1.10.11                                       │
│     ├── dbt-snowflake==1.10.1                                   │
│     ├── sqlfluff==3.4.2                                         │
│     └── sqlfluff-templater-dbt==3.4.2                           │
│                                                                  │
│  4. Download Snowflake Private Key                               │
│     └── From Azure Secure Files: snowflake_key.p8               │
│                                                                  │
│  5. Create dbt Profile                                           │
│     └── Generate profiles.yml with Snowflake connection         │
│     └── Uses key-pair authentication (more secure)              │
│                                                                  │
│  6. Run dbt deps                                                 │
│     └── Install dbt packages from packages.yml                  │
│                                                                  │
│  7. Run dbt parse                                                │
│     └── Generate manifest.json for SQLFluff dbt templater       │
│                                                                  │
│  8. Resolve Changed SQL Files                                    │
│     ├── For PRs: Compare HEAD to target branch                  │
│     └── For pushes: Compare HEAD to HEAD~1                      │
│                                                                  │
│  9. SQLFluff Lint                                                │
│     ├── Only lint changed .sql files                            │
│     ├── Output JSON for CI integration                          │
│     └── Output human-readable for developers                    │
│                                                                  │
│  10. Cleanup                                                     │
│      └── Remove private key from agent                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Why dbt templater?**
- SQLFluff needs to understand Jinja2 macros like `{{ ref('model') }}`
- The dbt templater compiles dbt models before linting
- This requires a valid Snowflake connection (hence the key-pair auth)

**Required Azure DevOps Setup:**
```yaml
# Secure Files:
- snowflake_key.p8        # Snowflake private key

# Pipeline Variables:
- SF_ACCOUNT              # Snowflake account (e.g., xy12345.us-east-1)
- SF_USER                 # Snowflake username
- SF_ROLE                 # Snowflake role
- SF_DATABASE             # Target database
- SF_WAREHOUSE            # Compute warehouse
- SF_SCHEMA               # Target schema
- SF_PRIVATE_KEY_PASSPHRASE  # Optional: key passphrase
```

---

### 2. `ci-yamllint.yml` - YAML Linting on Changed Files

**Purpose:** Lint only the YAML files that were changed in a PR/commit.

**When it runs:**
- On every push to any branch
- On every pull request

**What it does:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     ci-yamllint.yml                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Checkout Repository                                          │
│     └── Full git history for diff comparison                    │
│                                                                  │
│  2. Install yamllint                                             │
│     └── pip install yamllint                                    │
│                                                                  │
│  3. List Changed YAML Files                                      │
│     └── git diff origin/main | grep '\.yml$'                    │
│                                                                  │
│  4. Lint Each Changed File                                       │
│     └── yamllint $filename for each changed .yml file           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**What yamllint checks:**
- Indentation consistency (2 spaces)
- Line length (max 120)
- Trailing whitespace
- Key duplicates
- Proper quoting
- Empty lines

**Configuration:** Uses `.yamllint` file in repo root.

---

### 3. `ci-python.yml` - Python Linting on Changed Files

**Purpose:** Lint only the Python files that were changed in a PR/commit using Ruff.

**When it runs:**
- On every push to any branch
- On every pull request

**What it does:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     ci-python.yml                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Checkout Repository                                          │
│     └── Full git history for diff comparison                    │
│                                                                  │
│  2. Install Ruff                                                 │
│     └── pip install ruff                                        │
│                                                                  │
│  3. List Changed Python Files                                    │
│     └── git diff origin/main | grep '\.py$'                     │
│                                                                  │
│  4. Lint Each Changed File                                       │
│     └── ruff check $filename for each changed .py file          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Why Ruff instead of Black/Flake8/isort?**
- Ruff is 10-100x faster than traditional Python linters
- Single tool replaces Flake8, isort, and many other linters
- Compatible with Black formatting
- Written in Rust for maximum performance

**What Ruff checks:**
- Pycodestyle errors (E) and warnings (W)
- Pyflakes issues (F)
- Import sorting (I)
- Bug detection (B)
- Comprehension improvements (C4)
- Python upgrade suggestions (UP)

**Configuration:** Uses `[tool.ruff]` section in `pyproject.toml`.

---

### 4. `ci-secrets.yml` - Secrets Scanning

**Purpose:** Scan codebase for accidentally committed secrets, API keys, passwords, etc.

**When it runs:**
- On every pull request (not on push)

**What it does:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     ci-secrets.yml                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Checkout Repository                                          │
│                                                                  │
│  2. Install detect-secrets                                       │
│     └── pip install detect-secrets                              │
│                                                                  │
│  3. Scan Codebase                                                │
│     ├── Load existing baseline (.secrets.baseline)              │
│     ├── Scan all files for potential secrets                    │
│     └── Compare new findings to baseline                        │
│                                                                  │
│  4. Fail if New Secrets Detected                                 │
│     └── Block PR if secrets found that aren't in baseline       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**What detect-secrets finds:**
- AWS access keys
- Azure storage keys
- GitHub tokens
- Private keys
- JWT tokens
- Slack tokens
- Stripe API keys
- Basic auth credentials
- And many more...

**Baseline file:** `.secrets.baseline`
- Contains known/allowed "secrets" (e.g., example values, test data)
- New secrets must be added to baseline if intentional
- Review baseline changes carefully in PRs

---

### 5. `ci-gold-docs.yml` - Gold Layer Documentation Gate

**Purpose:** Ensure all Gold (marts) layer models have proper documentation and primary key tests.

**When it runs:**
- On every pull request (not on push)

**What it does:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     ci-gold-docs.yml                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Checkout Repository                                          │
│                                                                  │
│  2. Install PyYAML                                               │
│                                                                  │
│  3. Resolve Changed Gold SQL Files                               │
│     └── Find .sql files changed in hv_edp_dbt/models/gold/**   │
│                                                                  │
│  4. Validate Each Changed Model                                  │
│     │                                                            │
│     │  For each gold_*.sql file, check:                         │
│     │                                                            │
│     │  ✓ Schema YAML entry exists                               │
│     │    └── gold.yml must have "models: - name: gold_*"        │
│     │                                                            │
│     │  ✓ Model description exists                               │
│     │    └── "description: ..." must be non-empty               │
│     │                                                            │
│     │  ✓ Columns are documented                                 │
│     │    └── Each column needs a description                    │
│     │                                                            │
│     │  ✓ Primary key has tests                                  │
│     │    └── At least one column with BOTH:                     │
│     │        - unique                                           │
│     │        - not_null                                         │
│     │                                                            │
│  5. Fail PR if Validation Fails                                  │
│     └── Output JSON with specific errors per model              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Why this matters:**
- Gold layer is consumed by end users (BI tools, reports)
- Documentation ensures users understand the data
- PK tests ensure data integrity
- Catches undocumented models before they reach production

**Example of passing gold model documentation:**

```yaml
# gold.yml
models:
  - name: gold_fund_metrics
    description: "Aggregated fund performance metrics by as_of_date"
    columns:
      - name: hk_fund
        description: "Hash key of the fund (surrogate primary key)"
        tests:
          - unique
          - not_null
      - name: as_of_date
        description: "Date of the metric snapshot"
      - name: total_nav
        description: "Total Net Asset Value of the fund"
```

---

## CD Workflows

These workflows run on **merge to main** to deploy changes to production.

---

### 6. `cd-snowflake-perms.yml` - Snowflake Permissions

**Purpose:** Automatically grant Snowflake permissions when new sources are added.

**When it runs:**
- On merge to `main` branch
- Only when source YAML files change (`hv_edp_dbt/models/bronze/**/*.yml` or `sources.yml`)

**What it does:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     cd-snowflake-perms.yml                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Checkout Repository                                          │
│                                                                  │
│  2. Install Snowflake Connector                                  │
│     └── pip install snowflake-connector-python pyyaml           │
│                                                                  │
│  3. Detect New Databases                                         │
│     └── git diff to find new "database:" entries in YAML        │
│                                                                  │
│  4. Run Permissions Script                                       │
│     └── python/snowflake_permissions.py                         │
│                                                                  │
│     For each source defined in sources.yml:                     │
│                                                                  │
│     ├── GRANT USAGE ON DATABASE to role                         │
│     ├── GRANT USAGE ON SCHEMA to role                           │
│     ├── GRANT SELECT ON ALL TABLES IN SCHEMA                    │
│     ├── GRANT SELECT ON FUTURE TABLES IN SCHEMA                 │
│     ├── GRANT SELECT ON ALL VIEWS IN SCHEMA                     │
│     └── GRANT SELECT ON FUTURE VIEWS IN SCHEMA                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Why this is important:**
- When new source databases are added, dbt needs SELECT permissions
- Manual permission grants are error-prone and slow
- Automation ensures consistent access across environments

**Required Variable Group:** `Snowflake Service Account`
```yaml
# Create in Azure DevOps → Pipelines → Library → Variable Groups
SNOWFLAKE_ACCOUNT: xy12345.us-east-1
SNOWFLAKE_USER: DBT_SERVICE_ACCOUNT
SNOWFLAKE_PASSWORD: ********
SNOWFLAKE_ROLE: DBT_ADMIN
SNOWFLAKE_WAREHOUSE: DBT_WH
```

---

## Nightly Workflows

These workflows run on a **schedule** to catch issues that incremental checks might miss.

---

### 7. `nightly-sqlfluff.yml` - Full SQL Lint

**Purpose:** Lint the entire repository's SQL files, not just changed ones.

**When it runs:**
- Every day at 2:00 AM UTC
- Manual trigger available

**What it does:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     nightly-sqlfluff.yml                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                    PARALLEL EXECUTION                      │  │
│  │                                                            │  │
│  │   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │  │
│  │   │ Shard 1 │  │ Shard 2 │  │ Shard 3 │  │ Shard 4 │     │  │
│  │   │  25%    │  │  25%    │  │  25%    │  │  25%    │     │  │
│  │   │ files   │  │ files   │  │ files   │  │ files   │     │  │
│  │   └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘     │  │
│  │        │            │            │            │           │  │
│  │        └────────────┴─────┬──────┴────────────┘           │  │
│  │                           │                               │  │
│  │                     All Complete                          │  │
│  │                                                            │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                  │
│  Each Shard:                                                     │
│  1. Setup dbt + SQLFluff                                        │
│  2. Create Snowflake connection                                 │
│  3. Run dbt deps                                                │
│  4. Distribute files: file_index % 4 == shard_index            │
│  5. Lint assigned files                                         │
│  6. Report results                                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Why parallel shards?**
- Full repo lint can take 30+ minutes with dbt templater
- 4 parallel shards = ~4x faster (runs in ~8-10 minutes)
- Files distributed evenly using modulo arithmetic
- Each shard runs independently

**File distribution example:**
```
Total files: 100 SQL files

Shard 1: files 0, 4, 8, 12, 16, ...  (25 files)
Shard 2: files 1, 5, 9, 13, 17, ...  (25 files)
Shard 3: files 2, 6, 10, 14, 18, ... (25 files)
Shard 4: files 3, 7, 11, 15, 19, ... (25 files)
```

---

### 8. `nightly-yamllint.yml` - Full YAML Lint

**Purpose:** Lint all YAML files in the repository.

**When it runs:**
- Every day at 2:00 AM UTC

**What it does:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     nightly-yamllint.yml                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Checkout Repository                                          │
│                                                                  │
│  2. Install yamllint                                             │
│                                                                  │
│  3. List All YAML Files                                          │
│     └── git ls-files | grep '\.yml$'                            │
│                                                                  │
│  4. Lint Entire Repository                                       │
│     └── yamllint .                                              │
│                                                                  │
│  5. Report All Violations                                        │
│     └── Fail if any violations found                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Why nightly full lint?**
- Catches issues introduced by file moves/renames
- Validates entire codebase consistency
- Finds issues in files not changed recently

---

### 9. `nightly-python.yml` - Full Python Lint + Tests

**Purpose:** Lint all Python files AND run the complete test suite with coverage.

**When it runs:**
- Every day at 2:00 AM UTC

**What it does:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     nightly-python.yml                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Checkout Repository                                          │
│                                                                  │
│  2. Install Testing Tools                                        │
│     ├── pytest                                                  │
│     ├── pytest-azurepipelines                                   │
│     ├── pytest-cov                                              │
│     └── ruff                                                    │
│                                                                  │
│  3. Lint All Python Files                                        │
│     └── ruff check . (entire codebase)                          │
│     └── Continue on error (report but don't fail)               │
│                                                                  │
│  4. Run All Unit Tests                                           │
│     └── pytest tests/                                           │
│         ├── --doctest-modules                                   │
│         ├── --junitxml=junit/test-results.xml                   │
│         ├── --cov=hv_edp_dagster                                │
│         ├── --cov-report=xml                                    │
│         └── --cov-report=html                                   │
│                                                                  │
│  5. Publish Test Results                                         │
│     └── Azure DevOps test summary                               │
│                                                                  │
│  6. Publish Coverage Report                                      │
│     └── Cobertura coverage in Azure DevOps                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Test Coverage:**
- Tests run against `hv_edp_dagster` module
- Coverage report shows which code paths are tested
- HTML report available for detailed analysis
- JUnit XML integrates with Azure DevOps test tab

---

## Required Setup

### 1. Azure DevOps Secure Files

Upload to: Pipelines → Library → Secure Files

| File | Purpose |
|------|---------|
| `snowflake_key.p8` | Snowflake private key for dbt connection |

### 2. Azure DevOps Variable Groups

Create in: Pipelines → Library → Variable Groups

**Group: `Snowflake Service Account`**
| Variable | Description |
|----------|-------------|
| `SNOWFLAKE_ACCOUNT` | Account identifier (e.g., `xy12345.us-east-1`) |
| `SNOWFLAKE_USER` | Service account username |
| `SNOWFLAKE_PASSWORD` | Service account password (secret) |
| `SNOWFLAKE_ROLE` | Role for granting permissions |
| `SNOWFLAKE_WAREHOUSE` | Compute warehouse |

### 3. Pipeline Variables

Set in: Each pipeline → Variables

| Variable | Used By | Description |
|----------|---------|-------------|
| `SF_ACCOUNT` | ci-sqlfluff, nightly-sqlfluff | Snowflake account |
| `SF_USER` | ci-sqlfluff, nightly-sqlfluff | Snowflake user |
| `SF_ROLE` | ci-sqlfluff, nightly-sqlfluff | Snowflake role |
| `SF_DATABASE` | ci-sqlfluff, nightly-sqlfluff | Target database |
| `SF_WAREHOUSE` | ci-sqlfluff, nightly-sqlfluff | Compute warehouse |
| `SF_SCHEMA` | ci-sqlfluff, nightly-sqlfluff | Target schema |
| `SF_PRIVATE_KEY_PASSPHRASE` | ci-sqlfluff, nightly-sqlfluff | Key passphrase (optional) |
### 4. Dagster Jobs (Manual)

Dagster jobs are triggered **manually** - not automatically on merge.

After merging code to main:
1. Go to your Dagster UI
2. Navigate to the job you want to run
3. Click "Launch Run" or trigger via schedule

This gives you full control over when tables are built.

---

## Workflow Execution Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         DEVELOPER WORKFLOW                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. Developer creates branch                                            │
│     └── feature/add-new-fund-model                                      │
│                                                                          │
│  2. Developer pushes code                                               │
│     └── Triggers: ci-sqlfluff, ci-yamllint, ci-python                   │
│                                                                          │
│  3. Developer creates Pull Request                                       │
│     └── Triggers: ci-secrets, ci-gold-docs (in addition to above)       │
│                                                                          │
│  4. CI checks pass ✅                                                   │
│     └── PR is ready for review                                          │
│                                                                          │
│  5. PR approved and merged to main                                       │
│     └── Triggers: cd-snowflake-perms (if sources changed)               │
│                                                                          │
│  6. Manual Dagster Job Trigger                                           │
│     └── Developer manually triggers Dagster job to build tables         │
│     └── Tables are built when YOU decide, not automatically             │
│                                                                          │
│  7. Nightly (2 AM UTC)                                                   │
│     └── nightly-sqlfluff, nightly-yamllint, nightly-python              │
│     └── Full codebase validation                                         │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Troubleshooting

### SQLFluff CI Fails

1. **"No connection to Snowflake"**
   - Check `SF_*` variables are set
   - Verify `snowflake_key.p8` is uploaded to Secure Files
   - Ensure key passphrase is correct (if encrypted)

2. **"dbt parse failed"**
   - Check `packages.yml` exists and is valid
   - Run `dbt deps` locally to verify packages install

3. **"Linting violations"**
   - Run `sqlfluff lint` locally to see violations
   - Fix violations or update `.sqlfluff` rules

### Gold Docs CI Fails

1. **"No schema YAML entry found"**
   - Add model to `gold.yml` with `models: - name: your_model`

2. **"Model description missing"**
   - Add `description: "..."` to model in YAML

3. **"No column has BOTH tests: unique + not_null"**
   - Add tests to primary key column:
     ```yaml
     columns:
       - name: pk_column
         tests:
           - unique
           - not_null
     ```

### Snowflake Permissions Fails

1. **"Connection failed"**
   - Verify Snowflake Service Account variable group is configured
   - Check account, user, password are correct

2. **"Permission denied"**
   - Ensure service account has SECURITYADMIN or equivalent role
   - Check role has permissions to grant on target databases

---

*This document is auto-generated. For updates, modify the workflows in `.azuredevops/workflows/`.*
