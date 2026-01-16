---
description: Automatically fix linting issues across the codebase with language-specific tools
allowed-tools: Bash, Read, Grep, Glob
argument-hint: "[--scope=all|staged|file <path>] [--tool=auto|specific] [--dry-run]"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command automatically fixes linting issues using language-specific tools (cargo clippy --fix, eslint --fix, etc.). It intelligently detects the project type, runs appropriate fixers, and creates atomic commits for each category of fixes.

### Execution Steps

1.  **Parse Arguments**:

    **Scope flags**:
    - `--scope=all` (entire codebase, default)
    - `--scope=staged` (only staged files)
    - `--scope=file <path>` (specific file)

    **Tool flags**:
    - `--tool=auto` (detect and run all applicable tools, default)
    - `--tool=clippy` (Rust only)
    - `--tool=eslint` (JavaScript/TypeScript only)
    - `--tool=prettier` (Formatting only)
    - `--tool=ruff` (Python only)
    - `--tool=gofmt` (Go only)

    **Action flags**:
    - `--dry-run` (show what would be fixed without applying)
    - `--no-commit` (apply fixes but don't commit)
    - `--interactive` (ask before each fix category)

2.  **Detect Project Type and Available Tools**:

    a. **Check for language-specific files**:
    - Rust: `Cargo.toml`
    - TypeScript/JavaScript: `package.json`, `tsconfig.json`
    - Python: `pyproject.toml`, `setup.py`, `requirements.txt`
    - Go: `go.mod`
    - Java: `pom.xml`, `build.gradle`

    b. **Check for linter configuration**:
    - Rust: `clippy.toml`, `.cargo/config.toml`
    - TypeScript/JavaScript: `.eslintrc.*`, `.prettierrc.*`
    - Python: `pyproject.toml` (ruff config), `.flake8`
    - Go: `.golangci.yml`
    - Pre-commit hooks: `.lefthook.toml`

    c. **Verify tools are installed**:
    - Test each tool with version command
    - If tool missing, note in report and skip
    - Example: `cargo clippy --version`, `eslint --version`

    d. **Build tool execution plan**:

    ```
    Detected: Rust project
    Available tools:
    ✓ cargo fmt (formatting)
    ✓ cargo clippy (linting + auto-fix)
    ✗ rustfmt (not in PATH)

    Will run:
    1. cargo fmt --all
    2. cargo clippy --fix --allow-dirty --allow-staged
    ```

3.  **Run Linters in Dry-Run Mode First**:

    **Why**: Preview what will be fixed before applying changes

    a. **For each detected tool**:
    - Run in check/dry-run mode
    - Capture list of issues found
    - Categorize issues by type

    b. **Generate preview report**:

    ```markdown
    # Lint Fixes Preview

    ## cargo fmt

    - Files to format: 15
    - Estimated changes: formatting only

    ## cargo clippy --fix

    - Fixable issues: 23
      - needless_return: 8
      - redundant_field_names: 6
      - single_char_pattern: 5
      - unnecessary_unwrap: 4
    - Manual fixes required: 7
      - missing_docs: 5 (cannot auto-fix)
      - complexity: 2 (requires refactoring)

    Total auto-fixable: 23 issues across 12 files
    ```

    c. **If --dry-run flag**:
    - Show preview report
    - Exit without applying

4.  **Apply Fixes by Category**:

        **Fix categories** (in order):
        1. **Formatting** (lowest risk)
        2. **Import organization**
        3. **Simple lint fixes** (naming, unused vars)
        4. **Logic improvements** (clippy suggestions)

        a. **For each category**:

        i. **Confirm with user** (if --interactive):
        `Apply formatting fixes (cargo fmt)?

    Files affected: 15
    Risk: Low (formatting only)
    [Y/n]:
    `

        ii. **Run fixer**: - Execute tool with appropriate flags - Capture stdout/stderr - Check exit code

        iii. **Verify changes**: - Run `git diff --stat` to see what changed - Ensure changes are expected - If unexpected changes, STOP and report

        iv. **Run tests** (if available): - Quick smoke test: `cargo test`, `npm test`, etc. - If tests fail, REVERT changes and report error - Do NOT continue to next category if tests fail

        v. **Create atomic commit**:

               **IMPORTANT**: Read `~/.claude/commands/commit-atomic.md` to understand the
               commit message quality guidelines.

               Apply those same standards here, with these specifics:
               - **Type determination**:
                 - Formatting fixes → `style:`
                 - Lint fixes (naming, unused vars) → `refactor:` or `fix:`
                 - Logic improvements → `refactor:`
               - **Scope**: The tool name (e.g., `fmt`, `clippy`, `eslint`, `prettier`)
               - **Subject examples**:
                 - `style: apply cargo fmt formatting`
                 - `refactor: fix clippy needless_return warnings`
                 - `fix: resolve eslint no-unused-vars issues`
               - **Body**: Follow commit-atomic.md rules (include only when WHY isn't obvious)
               - **Validation**: Use the same validation checklist from commit-atomic.md

5.  **Language-Specific Fix Strategies**:

    ### Rust

    **Tools**:
    - `cargo fmt` - Code formatting
    - `cargo clippy --fix` - Lint fixes

    **Execution**:

    ```bash
    # 1. Format code
    cargo fmt --all

    # 2. Fix clippy lints
    cargo clippy --fix --allow-dirty --allow-staged --all-targets

    # 3. Test
    cargo test --quiet
    ```

    **Commit strategy**:
    - Commit 1: `style: apply cargo fmt formatting`
    - Commit 2: `refactor: fix clippy warnings (needless_return, redundant_field_names)`
    - Follow commit message guidelines from `~/.claude/commands/commit-atomic.md`

    **Edge cases**:
    - If `--allow-dirty` needed, ensure user knows uncommitted changes exist
    - Some clippy fixes require manual intervention (will note in report)

    ### TypeScript/JavaScript

    **Tools**:
    - `prettier` - Code formatting
    - `eslint --fix` - Lint fixes
    - `organize-imports-cli` - Import organization (if available)

    **Execution**:

    ```bash
    # 1. Format code
    npx prettier --write "src/**/*.{ts,tsx,js,jsx}"

    # 2. Organize imports (if tool available)
    npx organize-imports-cli "src/**/*.ts"

    # 3. Fix eslint issues
    npx eslint --fix "src/**/*.{ts,tsx,js,jsx}"

    # 4. Test
    npm test
    ```

    **Commit strategy**:
    - Commit 1: `style: apply prettier formatting`
    - Commit 2: `refactor: organize imports`
    - Commit 3: `fix: resolve eslint auto-fixable issues`
    - Follow commit message guidelines from `~/.claude/commands/commit-atomic.md`

    ### Python

    **Tools**:
    - `black` or `ruff format` - Code formatting
    - `isort` - Import sorting
    - `ruff check --fix` - Lint fixes

    **Execution**:

    ```bash
    # 1. Format code
    ruff format .
    # OR: black .

    # 2. Sort imports
    isort .
    # OR: ruff check --select I --fix .

    # 3. Fix lint issues
    ruff check --fix .

    # 4. Test
    pytest
    ```

    **Commit strategy**:
    - Commit 1: `style: apply ruff formatting`
    - Commit 2: `refactor: organize imports with isort`
    - Commit 3: `fix: resolve ruff auto-fixable issues`
    - Follow commit message guidelines from `~/.claude/commands/commit-atomic.md`

    ### Go

    **Tools**:
    - `gofmt` or `goimports` - Code formatting
    - `golangci-lint --fix` - Lint fixes

    **Execution**:

    ```bash
    # 1. Format and organize imports
    goimports -w .

    # 2. Fix lint issues
    golangci-lint run --fix

    # 3. Test
    go test ./...
    ```

    **Commit strategy**:
    - Commit 1: `style: apply goimports formatting`
    - Commit 2: `fix: resolve golangci-lint auto-fixable issues`
    - Follow commit message guidelines from `~/.claude/commands/commit-atomic.md`

6.  **Generate Summary Report**:

    ````markdown
    # Lint Fixes Applied

    **Completed**: 2025-02-15 14:45:00
    **Scope**: All files
    **Tools used**: cargo fmt, cargo clippy

    ## Summary

    ✅ **Formatting** (cargo fmt)

    - Files changed: 15
    - Commit: abc123f "style: apply cargo fmt formatting"

    ✅ **Lint fixes** (cargo clippy --fix)

    - Issues fixed: 23
      - needless_return: 8
      - redundant_field_names: 6
      - single_char_pattern: 5
      - unnecessary_unwrap: 4
    - Files changed: 12
    - Commit: def456a "refactor: fix clippy warnings"

    ⚠️ **Manual fixes required**

    - missing_docs: 5 items (cannot auto-fix)
      - src/domain/services/person_service.rs:45
      - src/domain/services/operation_service.rs:78
      - ... (3 more)
    - complexity: 2 items (requires refactoring)
      - src/api/handlers/persons.rs:handle_complex_query (complexity: 15)
      - src/utils/validation.rs:validate_input (complexity: 12)

    ## Test Results

    ✅ All tests passing (142 passed, 0 failed)

    ## Next Steps

    1. **Review commits**:
       ```bash
       git log --oneline -2
       ```
    ````

    1. **Address manual fixes**:
       - Add documentation for 5 undocumented items
       - Refactor 2 complex functions

    2. **Push changes**:

       ```bash
       git push origin <branch>
       ```

    ```

    ```

7.  **Handle Errors and Edge Cases**:

    **Tool not installed**:
    - Detect early in step 2
    - Skip that tool gracefully
    - Note in report: "eslint not found, skipping JavaScript linting"
    - Continue with other tools

    **Tests fail after fixes**:
    - IMMEDIATELY revert the fix that broke tests
    - Report which category of fixes caused failure
    - Include error output
    - Ask user if they want to continue with remaining fixes
    - DO NOT commit broken changes

    **Unexpected file changes**:
    - If fixer modifies files outside expected scope, STOP
    - Show diff of unexpected changes
    - Ask user to confirm before proceeding

    **No issues found**:
    - Report: "✅ No lint issues found! Code is clean."
    - Exit gracefully
    - Don't create empty commits

    **Merge conflicts or dirty working tree**:
    - Check `git status` before starting
    - If uncommitted changes exist, ask user:
      - Option A: Stash changes, run fixes, pop stash
      - Option B: Abort (user should commit first)
      - Option C: Continue with --allow-dirty (risky)

    **Partial failures**:
    - If some tools succeed and others fail
    - Commit successful fixes
    - Report failed tools with errors
    - Don't block successful fixes due to one failure

8.  **Validation**:

    **Before applying fixes**:
    - [ ] Project type detected correctly
    - [ ] Required tools are available
    - [ ] Scope is valid (files exist)
    - [ ] No merge conflicts in working tree
    - [ ] Dry-run preview generated

    **After each fix category**:
    - [ ] Only expected files changed
    - [ ] Changes align with tool's purpose
    - [ ] Tests pass (if test suite exists)
    - [ ] Commit created with good message

    **After all fixes**:
    - [ ] All tools ran successfully (or failures reported)
    - [ ] Test suite passes
    - [ ] Summary report generated
    - [ ] Manual fixes noted (if any)

## Examples

### Example 1: Auto-fix all issues (default)

**Command**: `/fix-lint`

**Output**:

```
Detecting project type...
✓ Detected: Rust project

Checking available tools...
✓ cargo fmt (v1.75.0)
✓ cargo clippy (v1.75.0)

Running linters in preview mode...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Preview: Fixable Issues

cargo fmt:
  Files to format: 15

cargo clippy --fix:
  Auto-fixable: 23 issues
    - needless_return: 8
    - redundant_field_names: 6
    - single_char_pattern: 5
    - unnecessary_unwrap: 4

  Manual fixes required: 7
    - missing_docs: 5
    - complexity: 2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Applying fixes...

[1/2] Running cargo fmt...
✅ Formatted 15 files

Running tests...
✅ Tests passed (142 passed)

Committing...
✅ abc123f style: apply cargo fmt formatting

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[2/2] Running cargo clippy --fix...
✅ Fixed 23 issues in 12 files

Running tests...
✅ Tests passed (142 passed)

Committing...
✅ def456a refactor: fix clippy warnings

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Lint fixes complete!

Summary:
  - 2 commits created
  - 23 issues auto-fixed
  - 7 issues require manual attention

Manual fixes needed:
  - Add docs: 5 items
  - Refactor complex functions: 2 items

Next steps:
  git log --oneline -2
  cargo clippy (to see remaining issues)
```

### Example 2: Dry-run mode

**Command**: `/fix-lint --dry-run`

**Output**:

```
Detecting project type...
✓ Detected: TypeScript project

Checking available tools...
✓ prettier (v3.0.0)
✓ eslint (v8.50.0)

Running linters in preview mode...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DRY RUN: Preview of Changes

prettier:
  Files to format: 42
  Estimated: formatting only (whitespace, semicolons)

eslint --fix:
  Auto-fixable: 67 issues across 18 files
    - no-unused-vars: 23
    - prefer-const: 18
    - no-console: 12
    - eqeqeq: 8
    - quotes: 6

  Cannot auto-fix: 15 issues
    - @typescript-eslint/no-explicit-any: 12
    - complexity: 3

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This is a DRY RUN. No changes were applied.

To apply these fixes, run:
  /fix-lint

To apply only formatting:
  /fix-lint --tool=prettier

To apply interactively:
  /fix-lint --interactive
```

### Example 3: Interactive mode

**Command**: `/fix-lint --interactive`

**Output**:

```
Detecting project type...
✓ Detected: Rust project

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1/2] Formatting (cargo fmt)

Files to format: 15
Risk: Low (formatting only, no logic changes)

Apply formatting fixes? [Y/n]: y

Running cargo fmt...
✅ Formatted 15 files
✅ Tests passed

✅ Committed: abc123f style: apply cargo fmt formatting

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[2/2] Lint fixes (cargo clippy --fix)

Auto-fixable issues: 23
  - needless_return: 8
  - redundant_field_names: 6
  - single_char_pattern: 5
  - unnecessary_unwrap: 4

Risk: Low-Medium (logic improvements, well-tested)

Apply clippy fixes? [Y/n]: y

Running cargo clippy --fix...
✅ Fixed 23 issues
✅ Tests passed

✅ Committed: def456a refactor: fix clippy warnings

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ All fixes applied!
```

### Example 4: Specific file

**Command**: `/fix-lint --scope=file src/domain/person_service.rs`

**Output**:

```
Running cargo clippy on src/domain/person_service.rs...

Found 3 auto-fixable issues:
  - needless_return: 2
  - redundant_field_names: 1

Applying fixes...
✅ Fixed 3 issues

Running tests for domain::services::person_service...
✅ Tests passed (8 passed)

✅ Committed: fix: resolve clippy warnings in person_service

Changes:
  src/domain/services/person_service.rs | 6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)
```

## Context

Additional user context: $ARGUMENTS
