---
description: Perform comprehensive code review analyzing changes for bugs, security, performance, and maintainability
allowed-tools: Bash, Read
argument-hint:
  [
    optional: --staged | --uncommitted | --pr | --base-branch develop | commit-sha | commit-sha..commit-sha2,
  ]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command performs a thorough code review of changes, analyzing for common issues, security vulnerabilities, performance problems, maintainability concerns, and adherence to project standards.

### Execution Steps

1. **Determine Review Scope**:

   Parse arguments to determine what to review:
   - `--staged`: Review only staged changes (`git diff --cached`)
   - `--uncommitted`: Review all uncommitted changes (staged + unstaged)
   - `--pr`: Review changes in current PR (diff from base branch, auto-detected or specified)
   - `--base-branch <branch>`: Specify base branch for --pr (otherwise auto-detect)
   - `<commit-sha>`: Review specific commit
   - `<commit-sha>..<commit-sha2>`: Review diff between two commits
   - No args: Default to uncommitted changes

   **Examples**:

   ```bash
   /review-code --staged
   /review-code --pr
   /review-code --pr --base-branch develop
   /review-code a1b2c3d
   /review-code a1b2c3d..d4e5f6g
   ```

2. **Intelligent Base Branch Detection** (for --pr without --base-branch):

   If `--pr` specified but `--base-branch` was NOT provided, auto-detect base branch:

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
   - ERROR: "Cannot auto-detect base branch. Please specify with --base-branch <branch>"

   f. **Report detected base branch**:

   ```
   🔍 Reviewing PR changes against: [branch-name]
   📍 Merge-base: [short-sha] ([relative-date])
   ```

3. **Gather Changes**:

   Based on scope:

   ```bash
   # For staged
   git diff --cached

   # For uncommitted
   git diff HEAD

   # For PR (with auto-detected or specified base)
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

4. **Analyze Project Context**:
   - Read CLAUDE.md for project standards
   - Read README.md for architecture overview
   - Identify language/framework from file extensions
   - Note project patterns from existing code
   - Check for .editorconfig, .prettierrc, etc.

5. **Perform Multi-Dimensional Review**:

   For each changed file, analyze across these dimensions:

   ### A. **Correctness & Bugs** (🐛)

   - Logic errors
   - Off-by-one errors
   - Null/undefined handling
   - Edge case coverage
   - Error handling completeness
   - Type mismatches (for typed languages)
   - Resource leaks (unclosed files, connections)
   - Race conditions
   - Deadlock potential

   ### B. **Security** (🔒)

   - SQL injection vulnerabilities
   - XSS vulnerabilities
   - Command injection
   - Path traversal
   - Authentication/authorization bypass
   - Sensitive data exposure
   - Insecure dependencies
   - CSRF protection
   - Input validation
   - Output encoding

   ### C. **Performance** (⚡)

   - Inefficient algorithms (O(n²) when O(n) possible)
   - Unnecessary loops or iterations
   - Database N+1 queries
   - Missing indexes
   - Excessive memory allocation
   - Blocking operations in async code
   - Missing caching opportunities
   - Large object copies
   - Inefficient data structures

   ### D. **Maintainability** (🔧)

   - Code clarity and readability
   - Function/method length (>50 lines?)
   - Cyclomatic complexity
   - Duplication (DRY violations)
   - Naming clarity
   - Magic numbers/strings
   - Comment quality (too few? too many?)
   - Modularity and separation of concerns
   - Testability

   ### E. **Best Practices** (✨)

   - Language idioms and conventions
   - Framework best practices
   - Project-specific patterns (from CLAUDE.md)
   - SOLID principles
   - Error handling patterns
   - Logging appropriateness
   - Dependency injection
   - Configuration management

   ### F. **Testing** (🧪)

   - Are tests included for new code?
   - Are tests comprehensive?
   - Edge cases tested?
   - Error paths tested?
   - Test quality and clarity
   - Test coverage gaps

   ### G. **Documentation** (📚)

   - Public API documented?
   - Complex logic explained?
   - Breaking changes noted?
   - Examples provided?
   - Documentation up to date?

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
   ````

   **Problem**:
   [Why this is critical]

   **Suggested Fix**:

   ```language
   [Better code]
   ```

   **Impact**: [What happens if not fixed]

   ***

   ## High Priority Issues 🟠

   [Similar format for each issue]

   ***

   ## Medium Priority Issues 🟡

   [Similar format]

   ***

   ## Low Priority Issues 🟢

   [Similar format]

   ***

   ## Positive Observations ✅

   [Highlight good things]:
   - Good error handling in [file:line]
   - Excellent test coverage for [feature]
   - Clear naming in [file:line]
   - Efficient algorithm used for [functionality]

   ***

   ## Recommendations

   ### Must Do (Before Merge)

   1. [Critical fix #1]
   2. [Critical fix #2]

   ### Should Do (Before Merge)

   1. [High priority fix #1]
   2. [High priority fix #2]

   ### Could Do (Follow-up)

   1. [Medium/Low priority improvements]

   ***

   ## Testing Gaps

   [If applicable]
   - Missing tests for [scenario]
   - Edge case not covered: [case]
   - Error path not tested: [path]

   ***

   ## Documentation Gaps

   [If applicable]
   - Public function [name] lacks documentation
   - Complex algorithm in [file:line] needs explanation
   - Breaking change not documented

   ***

   ## Performance Notes

   [If applicable]
   - O(n²) algorithm in [file:line] - consider [optimization]
   - Possible N+1 query in [file:line]
   - Large object copy in [file:line] - consider reference

   ***

   ## Security Notes

   [If applicable]
   - Potential [vulnerability] in [file:line]
   - Input validation missing for [parameter]
   - Sensitive data logging in [file:line]

   ***

   ## Next Steps

   1. [Immediate action item]
   2. [Next action item]

   **Estimated Time to Address**: [rough estimate]

   ```

   ```

8. **Provide Context-Aware Analysis**:
   - **For Rust**: Focus on ownership/borrowing issues, unsafe code, error handling with Result/Option
   - **For JavaScript/TypeScript**: Focus on type safety, async/await patterns, null/undefined
   - **For Python**: Focus on type hints, exception handling, PEP 8
   - **For SQL**: Focus on injection, indexes, N+1 queries
   - **For API code**: Focus on validation, auth, rate limiting, error responses

9. **Check Against Project Standards**:

   From CLAUDE.md, verify:
   - Naming conventions followed?
   - File organization correct?
   - Error handling patterns consistent?
   - Testing standards met?
   - Documentation requirements satisfied?

10. **Report Results**:

- Output the structured review report
- Provide clear severity counts
- Give actionable recommendations
- Suggest review decision (approve/request changes)

## Review Quality Guidelines

### Be Specific

❌ "This code is inefficient"
✅ "This nested loop is O(n²). Consider using a HashSet for O(n) lookup: [code example]"

### Provide Context

❌ "Fix this bug"
✅ "This will panic if agency_id is null. Add validation: `if agency_id.is_none() { return Err(...) }`"

### Suggest Solutions

❌ "Security issue here"
✅ "Potential SQL injection. Use parameterized query: `$1, $2` instead of string interpolation"

### Explain Impact

❌ "Bad practice"
✅ "This blocks the async runtime. Use `tokio::spawn_blocking` for CPU-intensive work to prevent starving other tasks"

### Balance Criticism with Positives

- Note good patterns and decisions
- Acknowledge tradeoffs made
- Highlight improvements from previous code
- Recognize when code is well-done

## Language-Specific Focus Areas

### Rust

- Ownership/borrowing issues
- Unsafe code justification
- Error handling (Result/Option)
- Panic potential
- Performance (unnecessary clones, allocations)
- Concurrency (Send/Sync, data races)
- Lifetime annotations clarity

### JavaScript/TypeScript

- Type safety (any usage)
- Null/undefined handling
- Async/await patterns
- Promise error handling
- Memory leaks (closures, event listeners)
- Bundle size impact

### Python

- Type hints
- Exception handling
- PEP 8 compliance
- List comprehensions vs loops
- Generator usage
- Context managers

### Go

- Error handling (nil checks)
- Goroutine leaks
- Channel deadlocks
- Defer usage
- Interface design

### Java/C #

- Null reference exceptions
- Resource disposal (try-with-resources, using)
- Thread safety
- Collection choices
- Exception hierarchy

## Edge Cases & Error Handling

**No Changes Found**:

```
✅ No changes to review

The working directory is clean. Specify a different scope:
- /review-code --staged (review staged changes)
- /review-code --pr (review PR changes)
- /review-code <commit-sha> (review specific commit)
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

## Example Output

````markdown
# Code Review Report

**Scope**: Uncommitted changes
**Files Changed**: 3
**Lines Changed**: +157 / -42
**Review Date**: 2025-11-17 15:30

---

## Summary

**Overall Assessment**: REQUEST CHANGES

**Critical Issues**: 1 🔴
**High Priority**: 2 🟠
**Medium Priority**: 3 🟡
**Low Priority**: 2 🟢

**Recommendation**: There is one critical security issue (SQL injection vulnerability) that must be fixed before merging. Additionally, two high-priority bug fixes are needed. The overall code quality is good, with clear naming and solid test coverage for happy paths. Address the critical and high-priority issues, then this will be ready to merge.

---

## Critical Issues 🔴

### src/api/handlers/persons.rs:45 - SQL Injection Vulnerability

**Category**: Security
**Severity**: CRITICAL

**Issue**:
User input is directly interpolated into SQL query without sanitization or parameterization.

**Current Code**:

```rust
let query = format!("SELECT * FROM persons WHERE id = '{}'", person_id);
```
````

**Problem**:
This allows SQL injection attacks. An attacker could provide `person_id = "'; DROP TABLE persons; --"` to execute arbitrary SQL.

**Suggested Fix**:

```rust
let query = "SELECT * FROM persons WHERE id = $1";
let result = conn.query(query, &[&person_id]).await?;
```

**Impact**: Critical security vulnerability allowing data theft, modification, or deletion.

---

## High Priority Issues 🟠

### src/domain/services/person_service.rs:78 - Potential Panic on None

**Category**: Bug
**Severity**: HIGH

**Issue**:
Calling `.unwrap()` on an Option without checking can cause panic.

**Current Code**:

```rust
let agency_id = auth.agency_id.unwrap();
```

**Problem**:
If `agency_id` is None, this will panic and crash the service. According to the codebase, agency_id should always be present after JWT validation, but defensive programming is better.

**Suggested Fix**:

```rust
let agency_id = auth.agency_id
    .ok_or(QueryError::Unauthorized("Missing agency_id in JWT"))?;
```

**Impact**: Service crashes on malformed JWTs, availability issue.

---

### src/domain/services/person_service.rs:102 - N+1 Query Problem

**Category**: Performance
**Severity**: HIGH

**Issue**:
Loading related data in a loop causes N+1 database queries.

**Current Code**:

```rust
for person in persons {
    let operations = load_operations(person.id).await?;
    person.operations = operations;
}
```

**Problem**:
If there are 100 persons, this makes 101 queries (1 for persons, 100 for operations). This doesn't scale.

**Suggested Fix**:

```rust
let person_ids: Vec<_> = persons.iter().map(|p| p.id).collect();
let all_operations = load_operations_batch(&person_ids).await?;
let operations_map: HashMap<_, _> = all_operations
    .into_iter()
    .into_group_map_by(|op| op.person_id);

for person in persons {
    person.operations = operations_map.get(&person.id).cloned().unwrap_or_default();
}
```

**Impact**: Poor performance at scale, database load increases linearly with result size.

---

## Medium Priority Issues 🟡

### src/api/handlers/persons.rs:120 - Error Details Leaking

**Category**: Security
**Severity**: MEDIUM

**Issue**:
Database error messages are being returned directly to clients.

**Current Code**:

```rust
.map_err(|e| AppError::DatabaseError(e.to_string()))
```

**Problem**:
Internal error details (table names, schema info) can help attackers. Error messages should be generic to external users.

**Suggested Fix**:

```rust
.map_err(|e| {
    error!("Database error: {}", e); // Log internally
    AppError::InternalError("Failed to fetch person") // Return generic message
})
```

**Impact**: Information disclosure, minor security concern.

---

### src/domain/services/person_service.rs:150 - Missing Test Coverage

**Category**: Testing
**Severity**: MEDIUM

**Issue**:
New cache invalidation function lacks tests.

**Problem**:
No tests verify cache invalidation works correctly, especially edge cases (non-existent keys, concurrent invalidation).

**Suggested Fix**:
Add tests:

```rust
#[tokio::test]
async fn test_cache_invalidation() { ... }

#[tokio::test]
async fn test_invalidate_nonexistent_key() { ... }

#[tokio::test]
async fn test_concurrent_invalidation() { ... }
```

**Impact**: Potential bugs in production, harder to maintain.

---

### src/domain/models/person_summary.rs:25 - Magic Number

**Category**: Maintainability
**Severity**: MEDIUM

**Issue**:
Hard-coded constant without explanation.

**Current Code**:

```rust
const MAX_OPERATIONS: usize = 100;
```

**Problem**:
No explanation why 100. Should be configurable or at least documented.

**Suggested Fix**:

```rust
/// Maximum operations to include in person summary.
/// Limited to prevent response size from growing unbounded.
/// Clients can fetch additional operations via pagination API.
const MAX_OPERATIONS: usize = 100;
```

**Impact**: Minor maintainability issue, unclear business rule.

---

## Low Priority Issues 🟢

### src/api/handlers/persons.rs:80 - Function Length

**Category**: Maintainability
**Severity**: LOW

**Issue**:
Function is 85 lines long, doing multiple things.

**Suggested Refactoring**:
Extract sub-functions:

- `validate_request()`
- `fetch_person_data()`
- `enrich_with_operations()`
- `format_response()`

**Impact**: Minor readability issue.

---

### src/domain/services/person_service.rs:60 - Naming Clarity

**Category**: Maintainability
**Severity**: LOW

**Issue**:
Variable name `res` is too generic.

**Current Code**:

```rust
let res = self.projection_client.read_projection(...).await?;
```

**Suggested Fix**:

```rust
let projection_data = self.projection_client.read_projection(...).await?;
```

**Impact**: Minor clarity improvement.

---

## Positive Observations ✅

- Excellent error handling structure using custom error types
- Good use of async/await patterns throughout
- Cache-aside pattern correctly implemented with TTL
- Strong type safety using newtype pattern for IDs
- Well-organized module structure following service layer pattern
- Good test coverage for happy paths
- Clear function naming and purpose
- Proper use of Rust ownership to prevent data races

---

## Recommendations

### Must Do (Before Merge)

1. Fix SQL injection vulnerability (person_id parameterization)
2. Replace `.unwrap()` with proper error handling
3. Fix N+1 query problem with batch loading

### Should Do (Before Merge)

1. Add tests for cache invalidation
2. Don't leak database error details to clients
3. Document MAX_OPERATIONS constant

### Could Do (Follow-up)

1. Refactor long functions for better readability
2. Improve variable naming (res → projection_data)

---

## Testing Gaps

- Cache invalidation not tested (edge cases)
- Concurrent access scenarios not tested
- Error path coverage incomplete (only happy paths)

---

## Security Notes

- **CRITICAL**: SQL injection in persons.rs:45
- Error message information disclosure (medium)
- Consider adding rate limiting to prevent abuse

---

## Performance Notes

- **HIGH**: N+1 query problem will impact scale
- Consider adding database indexes on agency_id
- Cache hit rate monitoring would be valuable

---

## Next Steps

1. Fix SQL injection (CRITICAL) - est. 15 minutes
2. Fix unwrap panic (HIGH) - est. 10 minutes
3. Fix N+1 query (HIGH) - est. 30-60 minutes
4. Add cache invalidation tests - est. 30 minutes
5. Generic error messages - est. 15 minutes

**Estimated Time to Address**: 1.5-2 hours

After addressing critical and high-priority issues, re-run review and I'll approve for merge.

```

## Context

User-provided arguments: $ARGUMENTS
```
