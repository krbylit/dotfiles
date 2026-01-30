---
description: Review local code changes for bugs, security, performance, and maintainability
allowed-tools: Bash, Read
argument-hint:
  [
    optional: --staged | --uncommitted | --base-branch <branch> | commit-sha | commit-sha..commit-sha2,
  ]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command performs a thorough code review of local changes, analyzing for common issues, security vulnerabilities, performance problems, maintainability concerns, and adherence to project standards. This is designed for reviewing changes before creating a PR.

### Execution Steps

1. **Determine Review Scope**:

   Parse arguments to determine what to review:
   - `--staged`: Review only staged changes (`git diff --cached`)
   - `--uncommitted`: Review all uncommitted changes (staged + unstaged)
   - `--base-branch <branch>`: Specify base branch for comparison (otherwise auto-detect)
   - `<commit-sha>`: Review specific commit
   - `<commit-sha>..<commit-sha2>`: Review diff between two commits
   - No args: Default to uncommitted changes against auto-detected base branch

   **Examples**:

   ```bash
   /review-changes --staged
   /review-changes --uncommitted
   /review-changes --base-branch feature/xyz
   /review-changes --uncommitted --base-branch develop
   /review-changes a1b2c3d
   /review-changes a1b2c3d..d4e5f6g
   ```

2. **Intelligent Base Branch Detection** (when --base-branch not specified):

   When reviewing uncommitted changes without an explicit `--base-branch` argument, auto-detect the base branch for context:

   a. **Check which standard branches exist**:

   ```bash
   # Check local and remote branches
   git branch --all | grep -E '(develop|main|master)$'
   ```

   b. **Find merge-base with each candidate**:

   ```bash
   # For develop (if exists)
   merge_base_develop=$(git merge-base HEAD develop 2>/dev/null)

   # For main (if exists)
   merge_base_main=$(git merge-base HEAD main 2>/dev/null)

   # For master (if exists)
   merge_base_master=$(git merge-base HEAD master 2>/dev/null)
   ```

   c. **Determine which merge-base is most recent**:

   ```bash
   # Get timestamp of each merge-base and compare
   # Select the branch with the newest merge-base
   ```

   d. **Select base branch** (priority order):
   1. `develop` (if merge-base exists and is most recent)
   2. `main` (if merge-base exists and is most recent, or if develop doesn't exist)
   3. `master` (if merge-base exists and is most recent, or if develop/main don't exist)

   e. **Validation**:
   - If detected base branch is NOT one of: develop, main, master
   - WARN: "Could not auto-detect base branch. Reviewing uncommitted changes only."

   f. **Report detected base branch** (if successful):

   ```
   🔍 Reviewing changes against: [branch-name]
   📍 Merge-base: [short-sha] ([relative-date])
   ```

3. **Gather Changes**:

   Based on scope:

   ```bash
   # For staged
   git diff --cached

   # For uncommitted (with base branch for context)
   git diff HEAD
   # Also show diff from base branch if detected/specified
   git diff <base-branch>...HEAD

   # For specific commit
   git show <commit-sha>

   # For commit range
   git diff <commit-sha>..<commit-sha2>
   # Or with triple-dot for merge-base comparison
   git diff <commit-sha>...<commit-sha2>
   ```

   **Note on commit ranges**:
   - `commit1..commit2`: All commits from commit1 to commit2 (exclusive of commit1)
   - `commit1...commit2`: Changes between merge-base of commit1 and commit2, and commit2
   - For review purposes, use `..` (two dots) for simple range
   - Parse syntax: If argument contains `..`, split on `..` to get two commit SHAs

   **Note on base branch usage**:
   - If `--base-branch <branch>` is specified, use that branch for comparison context
   - If not specified, use the auto-detected base branch from step 2
   - Use `git diff <base-branch>...HEAD` to show all changes since branching from base

4. **Analyze Project Context**:
   - Read CLAUDE.md for project standards
   - Read README.md for architecture overview
   - Identify language/framework from file extensions
   - Note project patterns from existing code
   - Check for .editorconfig, .prettierrc, etc.

5. **Perform Multi-Dimensional Review**:

   For each changed file, review for: **security, correctness, performance, maintainability, best practices, testing, and documentation**.

6. **Categorize Findings by Severity**:

   **🔴 CRITICAL**: Must fix before merging
   - Security vulnerabilities
   - Data corruption risks
   - Crashes/panics
   - Breaking changes without migration

   **🟠 HIGH**: Should fix before merging
   - Likely bugs
   - Performance issues
   - Poor error handling
   - Significant maintainability issues

   **🟡 MEDIUM**: Consider fixing
   - Potential bugs (edge cases)
   - Minor performance issues
   - Code clarity issues
   - Missing tests

   **🟢 LOW**: Nice to have
   - Style issues (if not auto-fixed)
   - Minor naming improvements
   - Documentation enhancements
   - Optimization opportunities

7. **Generate Review Report**:

Use this structured format:

````markdown
# Code Review Report

**Scope**: [what was reviewed]
**Files Changed**: [count]
**Lines Changed**: [+additions / -deletions]
**Review Date**: [timestamp]

---

## Summary

**Overall Assessment**: [APPROVE | APPROVE WITH COMMENTS | REQUEST CHANGES | REJECT]

**Critical Issues**: [count] 🔴
**High Priority**: [count] 🟠
**Medium Priority**: [count] 🟡
**Low Priority**: [count] 🟢

**Recommendation**: [One paragraph summary and recommendation]

---

## Critical Issues 🔴

[If any]

### [File:Line] - [Issue Title]

**Category**: [Security/Bug/etc]
**Severity**: CRITICAL

**Issue**:
[Description of the problem]

**Current Code**:

```language
[Problematic code snippet]
```

**Problem**:
[Why this is critical]

**Suggested Fix**:

```language
[Better code]
```

**Impact**: [What happens if not fixed]

---

## High Priority Issues 🟠

[Same format for each issue]

---

## Medium Priority Issues 🟡

[Same format for each issue]

---

## Low Priority Issues 🟢

[Same format for each issue]

---

## Positive Observations ✅

[Highlight good things]:

- Good error handling in [file:line]
- Excellent test coverage for [feature]
- Clear naming in [file:line]
- Efficient algorithm used for [functionality]

---

## Recommendations

### Must Do (Before Merge)

1.  [Critical fix #1]
2.  [Critical fix #2]

### Should Do (Before Merge)

1.  [High priority fix #1]
2.  [High priority fix #2]

### Could Do (Follow-up)

1.  [Medium/Low priority improvements]

---

## Testing Gaps

[If applicable]

- Missing tests for [scenario]
- Edge case not covered: [case]
- Error path not tested: [path]

---

## Documentation Gaps

[If applicable]

- Public function [name] lacks documentation
- Complex algorithm in [file:line] needs explanation
- Breaking change not documented

---

## Performance Notes

[If applicable]

- O(n²) algorithm in [file:line] - consider [optimization]
- Possible N+1 query in [file:line]
- Large object copy in [file:line] - consider reference

---

## Security Notes

[If applicable]

- Potential [vulnerability] in [file:line]
- Input validation missing for [parameter]
- Sensitive data logging in [file:line]

---

## Next Steps

1.  [Immediate action item]
2.  [Next action item]

```

```

8. **Report Results**:

   - Save the structured review report to a timestamped file in the repository root directory
   - Output a summary confirmation to the user
   - Provide clear severity counts
   - Give actionable recommendations
   - Suggest review decision (approve/request changes)

   **File Output**:
   - Generate filename: `CODE_REVIEW_<timestamp>.md` (e.g., `CODE_REVIEW_2025-01-29_143022.md`)
   - Timestamp format: `YYYY-MM-DD_HHMMSS`
   - Write the complete markdown report to this file
   - Confirm to user: `📝 Review saved to CODE_REVIEW_<timestamp>.md`

9. **Cross-Review Analysis (Senior Engineer Meta-Review)**:

    After writing the review file, check for other `CODE_REVIEW_*.md` files in the repository root:

    ```bash
    ls -1 CODE_REVIEW_*.md 2>/dev/null | grep -v "<current_review_filename>"
    ```

    **If other code review files exist**:

    a. **Read all existing CODE_REVIEW files** (excluding the one just written)

    b. **Act as a Senior Software Engineer** reviewing the work of junior engineers:
    - Treat all other CODE_REVIEW files as reviews written by junior engineers
    - Treat the current review as your own authoritative analysis
    - Apply critical evaluation to all claims and findings

    c. **Perform comparative analysis**:
    - Identify issues raised in other reviews that the current review missed
    - Evaluate the validity of each claim in other reviews
    - Note any false positives or over-reported issues in other reviews
    - Identify consensus findings (issues flagged by multiple reviews)
    - Note conflicting assessments between reviews

    d. **Append a "Cross-Review Analysis" section** to the current review file:

    ```markdown
    ---

    ## Cross-Review Analysis (Senior Engineer Meta-Review)

    **Reviews Analyzed**: [count] additional code review(s) found
    **Review Files**:

    - [list of other CODE_REVIEW filenames with timestamps]

    ### Missed Issues from Other Reviews

    [Issues flagged by other reviews that this review did not catch, with evaluation of their validity]

    | Source Review     | Issue   | Validity Assessment           | Action Recommended          |
    | ----------------- | ------- | ----------------------------- | --------------------------- |
    | CODE_REVIEW_xxx   | [issue] | Valid/Invalid/Partially Valid | Include/Dismiss/Investigate |

    ### Consensus Findings

    [Issues identified by multiple reviews - these have higher confidence]

    - [Issue]: Flagged by [N] reviews (this review + [list others])

    ### Conflicting Assessments

    [Where reviews disagree on severity or validity]

    | Issue   | This Review       | Other Review(s)    | Senior Assessment |
    | ------- | ----------------- | ------------------ | ----------------- |
    | [issue] | [this assessment] | [other assessment] | [final ruling]    |

    ### Questionable Claims in Other Reviews

    [Issues flagged by other reviews that appear to be false positives or overblown]

    - **[CODE_REVIEW_xxx]**: [claim] - **Assessment**: [why this is invalid/overblown]

    ### Summary of Review Quality

    **Most Thorough Review**: [which review, including this one, was most comprehensive]
    **Most Accurate Review**: [which review had the highest signal-to-noise ratio]
    **Key Gaps Across All Reviews**: [any issues that ALL reviews may have missed]

    ### Final Recommendations

    Based on cross-review analysis:

    1. [Consolidated action item accounting for all reviews]
    2. [Additional item if other reviews raised valid points]

    **Confidence Level**: [High/Medium/Low] - [explanation of confidence based on review consensus]
    ```

    e. **If no other CODE_REVIEW files exist**:
    - Do not append anything
    - Optionally note to user: "No other code review files found for cross-analysis"

10. **Check Against Project Standards**:

    From CLAUDE.md, verify:

    - Naming conventions followed?
    - File organization correct?
    - Error handling patterns consistent?
    - Testing standards met?
    - Documentation requirements satisfied?

## Review Quality Guidelines

**Be specific with examples**:
✅ "This nested loop is O(n²). Consider using a HashSet for O(n) lookup: [code example]"

**Provide context**:
✅ "This will panic if agency_id is null. Add validation: `if agency_id.is_none() { return Err(...) }`"

**Suggest solutions**:
✅ "Potential SQL injection. Use parameterized query: `$1, $2` instead of string interpolation"

**Balance criticism with positives**:
- Note good patterns and decisions
- Acknowledge tradeoffs made
- Highlight improvements from previous code

## Edge Cases & Error Handling

**No Changes Found**:

```
✅ No changes to review

The working directory is clean. Specify a different scope:
- /review-changes --staged (review staged changes)
- /review-changes <commit-sha> (review specific commit)
```

**Very Large Changes**:

- If >1000 lines changed, warn about thoroughness
- Suggest breaking into smaller reviews
- Focus on most critical files first

**Mixed Languages**:

- Review each language with appropriate lens
- Note if mixed languages in single file (SQL in strings, etc.)

**Auto-Generated Code**:

- Detect auto-generated files (headers, build output)
- Skip or note lighter review
- Focus on how generated code is used

**Test Files**:

- Apply appropriate criteria (test-specific patterns)
- Check for test quality, not production standards

## Context

User-provided arguments: $ARGUMENTS
