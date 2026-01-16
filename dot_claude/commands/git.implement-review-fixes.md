---
description: Read PR review files, validate suggested fixes, and implement user-selected fixes with atomic commits
allowed-tools: Bash, Read, Edit, Write
argument-hint: [optional: --auto-commit | --dry-run | --severity critical, high]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command reads all PR*REVIEW*\*.md files in the repository, extracts and validates suggested fixes, presents them to the user for selection, implements the chosen fixes, and commits changes following conventional commit patterns.

### Execution Steps

1. **Find PR Review Files**:

   ```bash
   # Find all PR review files in repository root
   ls -1 PR_REVIEW_*.md 2>/dev/null
   ```

   - If no files found: Report "No PR review files found" and exit
   - Sort by timestamp (most recent first)
   - Report count of review files found

2. **Parse Arguments**:
   - `--auto-commit`: Automatically commit each fix (default behavior)
   - `--no-commit`: Implement fixes but don't commit (leave staged)
   - `--dry-run`: Show what would be fixed without making changes
   - `--severity <levels>`: Filter by severity (e.g., `--severity critical,high`)
     - Valid levels: critical, high, medium, low
     - Comma-separated, case-insensitive
   - `--category <types>`: Filter by category (e.g., `--category security,bug`)
     - Valid types: security, bug, performance, maintainability, etc.

3. **Read and Parse All Review Files**:

   For each PR*REVIEW*\*.md file:

   a. **Extract Issues**:
   - Parse markdown structure to find all issues
   - Each issue should have:
     - **Severity**: Critical 🔴, High 🟠, Medium 🟡, Low 🟢
     - **Location**: `File:Line` reference
     - **Category**: Security, Bug, Performance, Maintainability, etc.
     - **Description**: What's wrong
     - **Current Code**: Code snippet showing problem
     - **Suggested Fix**: Code snippet with solution
     - **Impact**: Why it matters

   b. **Parse Location References**:
   - Extract file path and line number from references like:
     - `src/api/handlers/persons.rs:45`
     - `### [File:Line] - Issue Title`
     - `[file:line]` in text
   - Handle various formats flexibly

   c. **Extract Code Blocks**:
   - Find "Current Code" or "Problem" code blocks
   - Find "Suggested Fix" or "Better Code" code blocks
   - Preserve language tags and formatting

4. **Validate Each Issue**:

   For each extracted issue:

   a. **Check File Exists**:

   ```bash
   test -f <file_path>
   ```

   - If file doesn't exist: Mark as INVALID (file not found)

   b. **Check Code Still Present**:
   - Read the file at specified line
   - Check if "Current Code" matches or is similar
   - Allow for minor whitespace differences
   - If code has changed significantly: Mark as POSSIBLY_OUTDATED

   c. **Check Fix Applicability**:
   - Verify suggested fix is syntactically reasonable
   - Check fix doesn't reference non-existent APIs/functions
   - Mark as VALID if checks pass

   d. **Categorize Validity**:
   - `VALID`: File exists, code matches, fix applicable
   - `OUTDATED`: File exists but code has changed
   - `INVALID`: File missing or fix not applicable
   - `UNCERTAIN`: Can't determine automatically

5. **Apply Filters**:

   If `--severity` specified:
   - Only include issues matching specified severity levels

   If `--category` specified:
   - Only include issues matching specified categories

6. **Present Issues to User**:

   Generate numbered list with format:

   ````
   Found X valid issues across Y PR review files

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   [1] 🔴 CRITICAL - Security
       📍 src/api/handlers/persons.rs:45
       🐛 SQL Injection Vulnerability

       Current Code:
       ```rust
       let query = format!("SELECT * FROM persons WHERE id = '{}'", person_id);
       ```

       Suggested Fix:
       ```rust
       let query = "SELECT * FROM persons WHERE id = $1";
       let result = conn.query(query, &[&person_id]).await?;
       ```

       Impact: Critical security vulnerability allowing data theft
       Source: PR_REVIEW_2025-01-15_143022.md

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   [2] 🟠 HIGH - Bug
       📍 src/domain/services/person_service.rs:78
       🐛 Potential Panic on None

       Current Code:
       ```rust
       let agency_id = auth.agency_id.unwrap();
       ```

       Suggested Fix:
       ```rust
       let agency_id = auth.agency_id
           .ok_or(QueryError::Unauthorized("Missing agency_id in JWT"))?;
       ```

       Impact: Service crashes on malformed JWTs
       Source: PR_REVIEW_2025-01-15_143022.md

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   [Continue for all valid issues...]

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Summary:
   - 🔴 Critical: 1
   - 🟠 High: 2
   - 🟡 Medium: 3
   - 🟢 Low: 2

   Total: 8 valid issues

   Skipped (outdated/invalid): 3 issues
   ````

7. **Get User Selection**:

   Use AskUserQuestion tool to ask:

   ```
   Which issues would you like to implement fixes for?

   Options:
   - "all" - Fix all valid issues
   - "critical" - Fix only critical issues
   - "critical,high" - Fix critical and high priority
   - "1,3,5" - Fix specific issues by number
   - "1-5" - Fix range of issues
   - "none" - Cancel (don't fix anything)
   ```

   **Parse User Response**:
   - `all`: Select all valid issues
   - `critical`: Select all critical severity
   - `high`: Select all high severity
   - `critical,high`: Select critical and high
   - `1,3,5`: Select issues 1, 3, and 5
   - `1-5`: Select issues 1 through 5
   - `none` or empty: Exit without changes

8. **Implement Fixes**:

   For each selected issue (in order of severity: Critical → High → Medium → Low):

   a. **Prepare Fix**:
   - Read the current file
   - Locate the problematic code
   - Prepare the suggested fix
   - Verify syntax if possible

   b. **Apply Fix**:
   - Use Edit tool to replace current code with suggested fix
   - Handle indentation carefully
   - Preserve surrounding context

   c. **Verify Fix**:
   - Re-read the file to confirm change applied
   - If language has linter/formatter, consider running it
   - Check that file is still syntactically valid

   d. **Handle Failures**:
   - If fix fails to apply: Log error, mark as FAILED, continue
   - If verification fails: Revert change, mark as FAILED, continue
   - Track success/failure for final report

9. **Group Fixes for Commits**:

   Following git.commit-changes.md principles:

   a. **Group by Logical Units**:
   - Same file + same category → one commit
   - Same severity + related files → one commit
   - Security fixes → separate commits
   - Each logical fix should be atomic

   b. **Determine Commit Type**:
   - Security issues → `fix(security):`
   - Bug fixes → `fix:`
   - Performance → `perf:`
   - Refactoring → `refactor:`
   - Multiple categories → use primary category

   c. **Generate Commit Messages**:

   Follow conventional commit format:

   ```
   fix(security): prevent SQL injection in person queries

   Replaced string interpolation with parameterized queries to prevent
   SQL injection attacks in person lookup endpoint.

   Refs: PR_REVIEW_2025-01-15_143022.md Issue #1
   ```

   **Message Guidelines**:
   - Subject: `<type>(<scope>): <description>` (≤50 chars)
   - Type: fix, perf, refactor based on category
   - Scope: Module/component affected
   - Description: What was fixed (imperative mood)
   - Body: Why the fix matters (context from PR review)
   - Footer: Reference to PR review file and issue number

10. **Commit Changes**:

    If `--auto-commit` (default) or not `--no-commit`:

    For each logical group:

    ```bash
    # Stage files
    git add <file1> <file2>...

    # Commit with message
    git commit -m "$(cat <<'EOF'
    fix(security): prevent SQL injection in person queries

    Replaced string interpolation with parameterized queries to prevent
    SQL injection attacks in person lookup endpoint.

    Refs: PR_REVIEW_2025-01-15_143022.md Issue #1
    EOF
    )"
    ```

    If `--no-commit`:
    - Apply all fixes
    - Leave changes staged
    - Report what was changed
    - Let user commit manually

    If `--dry-run`:
    - Don't make any changes
    - Report what would be changed
    - Show proposed commit structure

11. **Generate Summary Report**:

    ```markdown
    # PR Review Fixes Implementation Report

    **Date**: 2025-01-15 16:45:22
    **Review Files Analyzed**: 2
    **Total Issues Found**: 11
    **Valid Issues**: 8
    **Outdated/Invalid**: 3

    ---

    ## Issues Selected for Implementation

    - 🔴 Critical: 1
    - 🟠 High: 2
    - 🟡 Medium: 3
    - 🟢 Low: 0

    **Total Selected**: 6 issues

    ---

    ## Implementation Results

    ### ✅ Successfully Fixed (5)

    1. [#1] 🔴 SQL Injection - src/api/handlers/persons.rs:45
       - Applied parameterized query fix
       - Committed: a1b2c3d - fix(security): prevent SQL injection

    2. [#2] 🟠 Panic on None - src/domain/services/person_service.rs:78
       - Added proper error handling
       - Committed: d4e5f6g - fix: handle missing agency_id safely

    [... continue for each successful fix ...]

    ### ❌ Failed to Fix (1)

    3. [#5] 🟡 Magic Number - src/domain/models/person_summary.rs:25
       - Reason: Code has changed, line no longer exists
       - Action: Manual review needed

    ---

    ## Commits Created

    1. `a1b2c3d` - fix(security): prevent SQL injection in person queries
    2. `d4e5f6g` - fix: handle missing agency_id safely
    3. `h7i8j9k` - perf: optimize person query batch loading

    **Total Commits**: 3

    ---

    ## Files Modified

    - src/api/handlers/persons.rs (2 fixes)
    - src/domain/services/person_service.rs (2 fixes)
    - src/domain/models/person_summary.rs (1 fix)

    **Total Files**: 3

    ---

    ## Next Steps

    ✅ All critical and high-priority issues fixed
    ⚠️ 1 issue requires manual attention
    📝 Review commits: git log -3 --oneline
    🧪 Run tests to verify fixes
    🚀 Push changes when ready

    ---

    ## Issues Requiring Manual Attention

    1. [#5] Magic Number Documentation (Medium)
       - File: src/domain/models/person_summary.rs:25
       - Reason: Code structure has changed
       - From: PR_REVIEW_2025-01-15_143022.md
       - Recommendation: Review manually
    ```

12. **Save Report**:
    - Generate filename: `PR_FIXES_<timestamp>.md`
    - Timestamp format: `YYYY-MM-DD_HHMMSS`
    - Write report to repository root
    - Confirm to user: `📝 Report saved to PR_FIXES_<timestamp>.md`

## Edge Cases & Error Handling

**No PR Review Files**:

```
❌ No PR review files found

Looking for files matching: PR_REVIEW_*.md
Search location: Repository root

Create a review first using:
  /review-changes --pr
```

**No Valid Issues**:

```
✅ No valid issues to fix

Found 5 issues in PR reviews, but all are:
- 3 outdated (code has changed)
- 2 invalid (files don't exist)

All issues may have already been addressed.
```

**All Issues Already Fixed**:

```
✅ All issues appear to be resolved

Checked 8 issues from PR reviews:
- 8 code patterns no longer present
- 0 issues still applicable

Great work! Consider archiving old PR review files.
```

**User Cancels**:

```
Canceled by user - no changes made
```

**Conflicting Changes**:

- If working directory is dirty, warn user
- Ask if they want to:
  - Stash changes and continue
  - Abort and commit current changes first
  - Continue anyway (risky)

**Fix Application Failure**:

- If Edit fails: Try Write as fallback
- If both fail: Log detailed error
- Continue with next issue
- Report failure in summary

**Syntax Errors After Fix**:

- If language has syntax checker, run it
- If syntax error detected:
  - Revert the change
  - Mark as failed
  - Include in manual review list

**Large Number of Issues**:

- If >20 valid issues, warn about commit volume
- Suggest filtering by severity: `--severity critical,high`
- Offer to batch similar fixes into fewer commits

## Validation

**Before Implementing Fix**:

- ✅ File exists and is readable
- ✅ Current code pattern is present
- ✅ Suggested fix is syntactically reasonable
- ✅ Fix doesn't introduce obvious new issues

**After Implementing Fix**:

- ✅ Change was successfully applied
- ✅ File is still valid (no syntax errors if checkable)
- ✅ Original issue pattern is no longer present

**Before Committing**:

- ✅ At least one file was modified
- ✅ Commit message follows conventional format
- ✅ All modified files are related to fix
- ✅ Working directory state is clean or expected

**After All Fixes**:

- ✅ All selected issues were attempted
- ✅ Success/failure tracked for each
- ✅ Commits created for successful fixes
- ✅ Report generated with full details

## Commit Message Patterns

### Security Fixes

```
fix(security): prevent SQL injection in person queries

Replaced string interpolation with parameterized queries ($1, $2)
to eliminate SQL injection vulnerability in person lookup endpoint.

Refs: PR_REVIEW_2025-01-15_143022.md Issue #1
```

### Bug Fixes

```
fix(auth): handle missing agency_id in JWT

Added proper Option handling with descriptive error instead of
unwrap() to prevent panic on malformed JWT tokens.

Refs: PR_REVIEW_2025-01-15_143022.md Issue #2
```

### Performance Fixes

```
perf(query): batch-load operations to prevent N+1

Replaced per-person operation queries with single batch query
using HashMap lookup. Reduces database load from O(n) to O(1).

Refs: PR_REVIEW_2025-01-15_143022.md Issue #3
```

### Refactoring

```
refactor(error): use generic error messages for clients

Replaced detailed database errors with generic messages while
preserving detailed logging internally. Prevents information
disclosure to potential attackers.

Refs: PR_REVIEW_2025-01-15_143022.md Issue #4
```

### Multiple Related Fixes

```
fix(validation): improve input validation in handlers

- Add null check for person_id parameter
- Validate agency_id format before query
- Return 400 Bad Request for invalid input

Refs: PR_REVIEW_2025-01-15_143022.md Issues #5,#6,#7
```

## Issue Parsing Strategies

### Pattern Matching for Locations

Look for these patterns to extract file:line references:

```regex
# Header format
### \[?([^:]+):(\d+)\]? - (.+)

# Inline format
([^:]+):(\d+)

# Common variations
File: ([^:]+), Line: (\d+)
Location: ([^:]+):(\d+)
```

### Code Block Extraction

Identify code blocks in these sections:

- "Current Code"
- "Problem"
- "Problematic code snippet"
- "Suggested Fix"
- "Better code"
- "Recommended"

Extract language tag and content:

````markdown
```rust
let query = format!("...");
```
````

### Severity Extraction

Map severity levels:

- `🔴` or "CRITICAL" → Critical
- `🟠` or "HIGH" → High
- `🟡` or "MEDIUM" → Medium
- `🟢` or "LOW" → Low

### Category Extraction

Look for category labels:

- Security, Bug, Performance, Maintainability
- Testing, Documentation, Style
- Extract from "Category:" field or section headers

## Context

User-provided arguments: $ARGUMENTS

## Example Workflow

```
$ /implement-review-fixes

Finding PR review files...
Found 2 PR review files:
  - PR_REVIEW_2025-01-15_143022.md
  - PR_REVIEW_2025-01-14_091233.md

Parsing review files...
Extracted 11 issues
Validating issues...

✅ 8 valid issues
⚠️  3 outdated/invalid issues

[Presents numbered list of 8 valid issues]

Which issues would you like to implement fixes for?

User: "critical,high"

Selected 3 issues (1 critical, 2 high)

Implementing fixes...

[1/3] 🔴 Fixing SQL injection in persons.rs:45
      ✅ Applied parameterized query fix
      ✅ Committed: a1b2c3d

[2/3] 🟠 Fixing panic in person_service.rs:78
      ✅ Added proper error handling
      ✅ Committed: d4e5f6g

[3/3] 🟠 Fixing N+1 query in person_service.rs:102
      ✅ Implemented batch loading
      ✅ Committed: h7i8j9k

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Successfully fixed 3 issues
📝 Created 3 commits
📄 Report saved to PR_FIXES_2025-01-15_164522.md

Next steps:
  - Review commits: git log -3 --oneline
  - Run tests: cargo test
  - Push changes: git push origin <branch>
```
