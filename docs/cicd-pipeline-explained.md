# CI/CD Pipeline Explained - Azure DevOps

## Overview

This is an **Azure DevOps YAML pipeline** that automates testing, validation, and deployment of your HV EDP platform across multiple environments.

---

## Pipeline Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    CODE PUSHED TO REPO                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  STAGE 1: VALIDATE (Always Runs)                                │
│  ────────────────────────────────────────────────────────────  │
│  • Python linting (black, flake8, isort)                        │
│  • dbt compile (SQL syntax validation)                          │
│  • SQLFluff lint (SQL quality)                                   │
│  • pytest (Python unit tests)                                    │
│  • Code coverage reporting                                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────┴─────────┐
                    │                   │
                    ▼                   ▼
    ┌──────────────────────┐  ┌──────────────────────┐
    │  Branch: develop     │  │  Branch: release/*   │
    │  → Deploy Dev        │  │  → Deploy UAT        │
    └──────────────────────┘  └──────────────────────┘
                    │                   │
                    ▼                   ▼
    ┌──────────────────────┐  ┌──────────────────────┐
    │  STAGE 2: DEV        │  │  STAGE 3: UAT        │
    │  • dbt run           │  │  • dbt run           │
    │  • dbt test          │  │  • dbt test          │
    └──────────────────────┘  └──────────────────────┘
                                        │
                                        ▼
                              ┌──────────────────────┐
                              │  Branch: main        │
                              │  → Deploy Prod       │
                              └──────────────────────┘
                                        │
                                        ▼
                              ┌──────────────────────┐
                              │  STAGE 4: PROD        │
                              │  • dbt run            │
                              │  • dbt test           │
                              └──────────────────────┘
```

---

## Section-by-Section Breakdown

### 1. Pipeline Triggers (Lines 11-29)

```yaml
trigger:
  branches:
    include:
      - main
      - develop
      - release/*
      - feature/*
  paths:
    exclude:
      - '*.md'
      - 'docs/**'

pr:
  branches:
    include:
      - main
      - develop
      - release/*
```

**What it does:**
- **Triggers on push** to: `main`, `develop`, `release/*`, `feature/*` branches
- **Triggers on PR** to: `main`, `develop`, `release/*` branches
- **Ignores:** Markdown files and docs folder (won't trigger pipeline)

**Why:**
- Prevents unnecessary runs when only documentation changes
- Ensures code changes always trigger validation

---

### 2. Build Agent (Lines 30-36)

```yaml
pool:
  vmImage: 'ubuntu-latest'

variables:
  pythonVersion: '3.12'
  dbtProjectDir: 'hv_edp_dbt'
  dagsterProjectDir: 'hv_edp_dagster'
```

**What it does:**
- Uses **Ubuntu Linux** virtual machine
- Sets reusable variables for Python version and project directories

**Why:**
- Consistent build environment
- Easy to update versions in one place

---

### 3. STAGE 1: VALIDATE (Lines 41-103)

**This stage ALWAYS runs** - it's your quality gate.

#### Step 1: Setup Python (Lines 48-51)
```yaml
- task: UsePythonVersion@0
  inputs:
    versionSpec: '$(pythonVersion)'
```
- Installs Python 3.12

#### Step 2: Install Dependencies (Lines 53-56)
```yaml
- script: |
    python -m pip install --upgrade pip
    pip install -r requirements.txt
```
- Upgrades pip
- Installs all Python packages from `requirements.txt`

#### Step 3: Python Linting (Lines 58-63)
```yaml
- script: |
    black --check $(dagsterProjectDir)
    flake8 $(dagsterProjectDir)
    isort --check-only $(dagsterProjectDir)
```
- **black**: Checks code formatting
- **flake8**: Checks code style and errors
- **isort**: Checks import sorting
- **`continueOnError: false`**: Pipeline fails if linting fails

#### Step 4: Install dbt Packages (Lines 65-67)
```yaml
- script: |
    dbt deps --project-dir $(dbtProjectDir)
```
- Installs dbt packages (like `dbt_utils`)

#### Step 5: dbt Compile (Lines 69-79)
```yaml
- script: |
    dbt compile --project-dir $(dbtProjectDir) --target shared_dev
```
- **Validates SQL syntax** - ensures all SQL compiles correctly
- Uses `shared_dev` target (doesn't actually run, just validates)
- Requires Snowflake credentials (for connection validation)

#### Step 6: SQLFluff Lint (Lines 81-84)
```yaml
- script: |
    sqlfluff lint hv_edp_dbt/models/ hv_edp_dbt/macros/ --dialect=snowflake --templater=dbt
```
- **Lints SQL code** for style and quality
- **`continueOnError: true`**: Pipeline continues even if SQLFluff finds issues (warnings, not blockers)

#### Step 7: Python Tests (Lines 86-89)
```yaml
- script: |
    pytest tests/ -v --junitxml=test-results.xml --cov=hv_edp_dagster --cov-report=xml
```
- Runs pytest unit tests
- Generates JUnit XML for test reporting
- Generates code coverage report
- **`continueOnError: true`**: Tests can fail without blocking (you might want to change this)

#### Step 8: Publish Coverage (Lines 91-96)
```yaml
- task: PublishCodeCoverageResults@1
  inputs:
    codeCoverageTool: 'Cobertura'
    summaryFileLocation: 'coverage.xml'
```
- Publishes code coverage to Azure DevOps dashboard

#### Step 9: Publish Test Results (Lines 98-102)
```yaml
- task: PublishTestResults@2
  inputs:
    testResultsFiles: 'test-results.xml'
    testRunTitle: 'Python Tests'
```
- Publishes test results to Azure DevOps dashboard

---

### 4. STAGE 2: DEPLOY DEV (Lines 107-152)

**Runs ONLY when:**
- Validate stage succeeds ✅
- Branch is `develop` ✅

```yaml
condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/develop'))
```

**What it does:**
1. **Setup** (Lines 125-128): Install dependencies
2. **dbt run** (Lines 130-140): Execute all dbt models in `shared_dev` environment
3. **dbt test** (Lines 142-152): Run data quality tests

**Environment:**
- Database: `HV_EDP_DEV`
- Schema: `DEV`
- Uses service account credentials

---

### 5. STAGE 3: DEPLOY UAT (Lines 157-202)

**Runs ONLY when:**
- Validate stage succeeds ✅
- Branch starts with `release/` ✅

```yaml
condition: and(succeeded(), startsWith(variables['Build.SourceBranch'], 'refs/heads/release/'))
```

**What it does:**
- Same as Dev stage, but deploys to UAT environment
- Uses `SNOWFLAKE_USER_UAT` and `SNOWFLAKE_ROLE_UAT` variables
- Database: `HV_EDP_UAT`

**Typical workflow:**
```
develop → release/v1.2.0 → UAT deployment → manual testing → merge to main
```

---

### 6. STAGE 4: DEPLOY PROD (Lines 207-252)

**Runs ONLY when:**
- Validate stage succeeds ✅
- Branch is `main` ✅

```yaml
condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
```

**What it does:**
- Same as other stages, but deploys to **PRODUCTION**
- Uses `SNOWFLAKE_USER_PROD`, `SNOWFLAKE_WH_PROD`, `SNOWFLAKE_ROLE_PROD`
- Database: `HV_EDP_PRD`

**⚠️ IMPORTANT:** This is production! Usually requires:
- Manual approval (configured in Azure DevOps environment)
- Code review
- Sign-off

---

## Environment Variables

Each stage uses different Snowflake credentials:

| Stage | User Variable | Role Variable | Warehouse Variable |
|-------|--------------|---------------|-------------------|
| **Dev** | `SNOWFLAKE_USER` | `SNOWFLAKE_ROLE` | `SNOWFLAKE_WH` |
| **UAT** | `SNOWFLAKE_USER_UAT` | `SNOWFLAKE_ROLE_UAT` | `SNOWFLAKE_WH` |
| **Prod** | `SNOWFLAKE_USER_PROD` | `SNOWFLAKE_ROLE_PROD` | `SNOWFLAKE_WH_PROD` |

**These are set in Azure DevOps:**
- Pipelines → Library → Variable Groups
- Or Pipeline → Variables (secret variables)

---

## Branch Strategy

```
┌─────────────┐
│   feature/  │ ──┐
└─────────────┘   │
                  │ Merge
┌─────────────┐   │
│   develop   │ ◄─┘ ──► Deploy to DEV
└─────────────┘
                  │
                  │ Create release branch
                  ▼
┌─────────────┐
│ release/*   │ ──► Deploy to UAT
└─────────────┘
                  │
                  │ After UAT approval
                  ▼
┌─────────────┐
│    main     │ ──► Deploy to PROD
└─────────────┘
```

---

## What Happens When You Push Code?

### Scenario 1: Push to `develop` branch

```
1. Validate stage runs
   ✅ Python linting
   ✅ dbt compile
   ✅ SQLFluff
   ✅ pytest
   
2. If Validate passes → Deploy Dev stage runs
   ✅ dbt run (creates/updates tables in DEV)
   ✅ dbt test (validates data quality)
```

### Scenario 2: Push to `release/v1.2.0` branch

```
1. Validate stage runs
   
2. If Validate passes → Deploy UAT stage runs
   ✅ dbt run (creates/updates tables in UAT)
   ✅ dbt test
```

### Scenario 3: Push to `main` branch

```
1. Validate stage runs
   
2. If Validate passes → Deploy Prod stage runs
   ⚠️  Usually requires manual approval
   ✅ dbt run (creates/updates tables in PROD)
   ✅ dbt test
```

### Scenario 4: Push to `feature/my-feature` branch

```
1. Only Validate stage runs
   ✅ All checks pass/fail
   ❌ No deployment (feature branch)
```

---

## Key Concepts

### `continueOnError: true`
- Pipeline continues even if this step fails
- Used for warnings (SQLFluff, pytest) that shouldn't block deployment

### `continueOnError: false` (or omitted)
- Pipeline **stops** if this step fails
- Used for critical checks (Python linting, dbt compile)

### `condition:`
- Controls when a stage runs
- Example: `condition: and(succeeded(), eq(...))` means "only if previous stage succeeded AND branch matches"

### `dependsOn:`
- Defines stage dependencies
- `dependsOn: Validate` means "run after Validate stage"

---

## Common Issues & Solutions

### Issue 1: Pipeline fails on dbt compile
**Cause:** SQL syntax error or missing Snowflake credentials
**Solution:** 
- Check SQL syntax locally: `dbt compile --project-dir hv_edp_dbt`
- Verify Azure DevOps variables are set

### Issue 2: SQLFluff finds issues
**Cause:** SQL doesn't match style rules
**Solution:**
- Run locally: `sqlfluff fix hv_edp_dbt/models/`
- Or adjust `.sqlfluff` config

### Issue 3: Tests fail but pipeline continues
**Cause:** `continueOnError: true` on pytest step
**Solution:**
- Change to `continueOnError: false` if you want tests to block deployment
- Or fix the failing tests

### Issue 4: Deployment doesn't run
**Cause:** Branch name doesn't match condition
**Solution:**
- Check branch name matches: `develop`, `release/*`, or `main`
- Check Validate stage succeeded

---

## Best Practices

1. **Always run Validate locally first:**
   ```bash
   black --check hv_edp_dagster/
   dbt compile --project-dir hv_edp_dbt
   pytest tests/
   ```

2. **Test in Dev before UAT:**
   - Push to `develop` → Deploy Dev
   - Test in Dev environment
   - Create `release/*` branch → Deploy UAT

3. **Never push directly to `main`:**
   - Always go through: `develop` → `release/*` → `main`
   - This ensures proper testing

4. **Monitor pipeline results:**
   - Check Azure DevOps dashboard
   - Review test results and coverage
   - Fix issues before merging

---

## Summary

This pipeline implements a **4-stage deployment strategy**:

1. **Validate** (always) - Quality checks
2. **Dev** (develop branch) - Development environment
3. **UAT** (release/* branch) - User acceptance testing
4. **Prod** (main branch) - Production

Each stage builds on the previous one, ensuring code quality and proper testing before production deployment.
