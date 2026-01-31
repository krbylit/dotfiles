---
description: Review the current branch's pull request on GitHub with comprehensive analysis
allowed-tools: Bash, Read
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command performs a thorough code review of the pull request associated with the current branch, analyzing for common issues, security vulnerabilities, performance problems, maintainability concerns, and adherence to project standards.

### Execution Steps

1. **Detect and Validate Pull Request**:

   a. **Check if `gh` CLI is available**:

   ```bash
   # Verify gh is installed
   if ! command -v gh &> /dev/null; then
       echo "❌ gh CLI not found - required for PR review"
       exit 1
   fi
   ```

   b. **Check if repository has GitHub remote**:

   ```bash
   # Check for GitHub remote
   git remote -v | grep -q "github.com"
   if [ $? -ne 0 ]; then
       echo "❌ No GitHub remote found - this command requires a GitHub repository"
       exit 1
   fi
   ```

   c. **Detect PR for current branch**:

   ```bash
   # Try to get PR number for current branch
   PR_NUMBER=$(gh pr view --json number --jq '.number' 2>/dev/null)

   if [ -z "$PR_NUMBER" ]; then
       echo "❌ No PR found for current branch"
       echo "💡 Create a PR first or switch to a branch with an open PR"
       exit 1
   else
       echo "✅ Found PR #$PR_NUMBER for current branch"
   fi
   ```

   d. **Get PR metadata**:

   ```bash
   # Fetch PR details
   gh pr view $PR_NUMBER --json title,state,author,url,baseRefName,headRefName
   ```

   e. **Store PR info for later use**:
   - PR number
   - PR title
   - PR state (open/closed/merged)
   - Base branch (from PR metadata)
   - Head branch
   - PR URL
   - PR author

2. **Fetch Existing PR Comments and Reviews**:

   a. **Fetch unresolved review comments** (line-specific comments):

   ```bash
   # Get review comments (only unresolved conversations)
   # Using GitHub API to access 'resolved' field
   gh api "/repos/{owner}/{repo}/pulls/$PR_NUMBER/comments" \
       --jq '.[] | select(.in_reply_to_id == null or .in_reply_to_id == 0) |
             select(.pull_request_review_id != null) |
             {
               id: .id,
               path: .path,
               line: .line,
               body: .body,
               user: .user.login,
               created_at: .created_at,
               commit_id: .commit_id
             }'
   ```

   **Note**: GitHub's API doesn't directly expose "resolved" status on individual comments. Instead:
   - Fetch all review comments
   - Group them by thread (using `in_reply_to_id`)
   - If available via API, filter by resolved status
   - Otherwise, fetch all comments and note that filtering may be incomplete

   b. **Fetch general PR comments** (conversation tab):

   ```bash
   # Get issue comments (general PR discussion)
   gh api "/repos/{owner}/{repo}/issues/$PR_NUMBER/comments" \
       --jq '.[] | {
         id: .id,
         body: .body,
         user: .user.login,
         created_at: .created_at
       }'
   ```

   c. **Fetch PR reviews** (approve/request changes/comment):

   ```bash
   # Get PR reviews
   gh pr view $PR_NUMBER --json reviews \
       --jq '.reviews[] | {
         id: .id,
         state: .state,
         body: .body,
         author: .author.login,
         submitted_at: .submittedAt
       }'
   ```

   d. **Organize comment data**:
   - Categorize by type: review comments (line-specific) vs general comments
   - Extract file paths and line numbers for review comments
   - Note comment authors and timestamps
   - Store for later analysis

3. **Update All Branches to Latest**:

   **CRITICAL**: Ensure you're reviewing the actual current state, not stale local copies.

   ```bash
   # Fetch latest from remote
   git fetch origin

   # Update base branch to latest
   git fetch origin <base-branch>:<base-branch>

   # Update PR branch (head branch) to latest
   git fetch origin <head-branch>:<head-branch>
   ```

   If the fetch commands fail (e.g., branches don't exist locally), use:

   ```bash
   # Alternative: update current branch if you're on the PR branch
   git pull origin <head-branch>
   ```

   **Verify branches are up to date**:
   ```bash
   # Confirm base branch is current
   git log origin/<base-branch> --oneline -1

   # Confirm head branch is current
   git log origin/<head-branch> --oneline -1
   ```

4. **Gather Changes**:

   Use the base branch from PR metadata:

   ```bash
   # Get diff from base branch to HEAD
   git diff <base-branch>...HEAD
   ```

   Also gather commit information:

   ```bash
   # Get commit list for PR
   git log <base-branch>..HEAD --oneline

   # Get detailed commit history
   git log <base-branch>..HEAD
   ```

5. **Analyze Project Context**:
   - Read CLAUDE.md for project standards
   - Read README.md for architecture overview
   - Identify language/framework from file extensions
   - Note project patterns from existing code
   - Check for .editorconfig, .prettierrc, etc.

6. **Perform Multi-Dimensional Review**:

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

7. **Categorize Findings by Severity**:

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

8. **Evaluate Existing PR Comments**:

   For each comment/review fetched in step 2, perform analysis:

   a. **Read the current code at the flagged location**:
   - For line-specific review comments: Read the file at the specified path and line
   - Check if the code still exists at that location
   - Check if the code has changed since the comment was made (compare commit_id)

   b. **Assess comment validity**:
   - **Valid & Still Applicable**: Issue raised is legitimate and still present in current code
   - **Valid & Addressed**: Issue was legitimate but has been fixed
   - **Invalid/Outdated**: Comment no longer applies (code changed, was incorrect, or based on misunderstanding)
   - **Partially Valid**: Some aspects addressed, others remain

   c. **Verify fixes for addressed issues**:
   - If comment suggests a fix, check if that exact fix or equivalent was applied
   - Note if fix was applied but differently than suggested
   - Check if fix introduced new issues

   d. **Cross-reference with current review findings**:
   - Do current review findings overlap with PR comments?
   - Are there issues flagged in comments that current review missed?
   - Are there issues current review found that comments didn't mention?

   e. **Categorize comment evaluation results**:
   - **Consensus Issues**: Flagged in both PR comments AND current review
   - **New Issues in Current Review**: Not mentioned in PR comments
   - **Addressed Issues**: Flagged in comments but fixed in current code
   - **Still Outstanding**: Flagged in comments and still present
   - **Questionable Comments**: Comments that appear invalid or incorrect

9. **Generate Review Report**:

Use this structured format:

````markdown
# Pull Request Review

**PR**: [#number - title]
**URL**: [pr-url]
**Author**: @[author]
**Base Branch**: [base-branch]
**Review Date**: [timestamp]

**Files Changed**: [count]
**Lines Changed**: [+additions / -deletions]
**Commits**: [count]

---

## Summary

**Overall Assessment**: [APPROVE | APPROVE WITH COMMENTS | REQUEST CHANGES | REJECT]

**Critical Issues**: [count] 🔴
**High Priority**: [count] 🟠
**Medium Priority**: [count] 🟡
**Low Priority**: [count] 🟢

**Recommendation**: [One paragraph summary and recommendation]

### All Issues (Quick Reference)

This section provides concise, technical comments for every issue found, suitable for direct use in PR review comments. These are aimed at expert Software Engineers and focus on the "what" and "why" with minimal verbosity.

**Critical Issues 🔴**

1. **[file:line]** - [Brief issue description]

   ```language
   [Code excerpt showing the issue]
   ```

   [1-3 sentence technical comment explaining the issue and impact. Include suggested fix if helpful or if complexity requires it.]

2. **[file:line]** - [Brief issue description]

   [Continue pattern...]

**High Priority Issues 🟠**

[Same format as Critical Issues]

**Medium Priority Issues 🟡**

[Same format as Critical Issues]

**Low Priority Issues 🟢**

[Same format as Critical Issues]

---

## Critical Issues 🔴

[If any - detailed sections with full analysis]

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

[Similar format for each issue]

---

## Medium Priority Issues 🟡

[Similar format]

---

## Low Priority Issues 🟢

[Similar format]

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

## Existing PR Comments Analysis 💬

**PR Information**:
- **PR Number**: #[number]
- **PR Title**: [title]
- **PR State**: [open/closed/merged]
- **PR URL**: [url]
- **Base Branch**: [branch]

**Comments Analyzed**:
- **Review Comments** (line-specific): [count]
- **General Comments**: [count]
- **PR Reviews**: [count]

---

### Addressed Issues ✅

[Issues that were flagged in PR comments but have been fixed in current code]

| Location    | Commenter | Issue Raised         | Status   | Verification       |
| ----------- | --------- | -------------------- | -------- | ------------------ |
| [file:line] | @[user]   | [summary of comment] | Fixed ✅ | [How it was fixed] |

---

### Outstanding Issues ⚠️

[Issues flagged in PR comments that are still present in current code]

| Location    | Commenter | Issue Raised | Current Review Severity | Still Valid?     |
| ----------- | --------- | ------------ | ----------------------- | ---------------- |
| [file:line] | @[user]   | [summary]    | 🔴/🟠/🟡/🟢             | Yes/Partially/No |

**Details for each**:

- **[file:line]** - @[user] ([timestamp])
  - **Comment**: [full comment text]
  - **Current Code**:
    ```language
    [relevant code snippet]
    ```
  - **Assessment**: [Is this still valid? Why/why not?]
  - **Action Required**: [What needs to be done?]

---

### Consensus Issues 🎯

[Issues identified by BOTH PR comments AND current review - high confidence]

| Issue           | Flagged By                      | Severity    | Agreement Level |
| --------------- | ------------------------------- | ----------- | --------------- |
| [issue summary] | @[user1], @[user2], this review | 🔴/🟠/🟡/🟢 | Full/Partial    |

**Details**:

- **[Issue]**:
  - **PR Comment** (@[user]): [summary of their concern]
  - **Current Review**: [our finding]
  - **Agreement**: [Full agreement / Both found issue but different severity / Similar concerns]
  - **Recommendation**: [Since multiple reviewers agree, this should be high priority]

---

### Issues Only in Current Review 🆕

[Issues found by current review but NOT mentioned in any PR comments]

| Location    | Issue   | Severity    | Why Might This Be Missed?                            |
| ----------- | ------- | ----------- | ---------------------------------------------------- |
| [file:line] | [issue] | 🔴/🟠/🟡/🟢 | [Possible reason previous reviewers didn't catch it] |

---

### Questionable/Outdated Comments ❓

[PR comments that appear invalid, outdated, or incorrect]

| Location    | Commenter | Comment   | Assessment                            |
| ----------- | --------- | --------- | ------------------------------------- |
| [file:line] | @[user]   | [summary] | Invalid/Outdated/Incorrect - [reason] |

**Details**:

- **[file:line]** - @[user] comment:
  - **Comment**: [full text]
  - **Why Invalid**: [Code has changed / Comment was incorrect / Misunderstanding / etc.]
  - **Current State**: [What the code actually does now]

---

### Reviewer Agreement Summary

**Total PR Comments Evaluated**: [count]

| Category                         | Count | Percentage |
| -------------------------------- | ----- | ---------- |
| Addressed ✅                     | [N]   | [%]        |
| Still Outstanding ⚠️             | [N]   | [%]        |
| Consensus with Current Review 🎯 | [N]   | [%]        |
| Outdated/Invalid ❓              | [N]   | [%]        |

**Key Takeaways**:

- [Summary of how well issues have been addressed]
- [Note any patterns in what's been fixed vs outstanding]
- [Comment on review quality/usefulness]

---

### Recommended Actions Based on PR Comments

**Must Address**:

1. [Outstanding critical/high issues from PR comments]
2. [Consensus issues flagged by multiple reviewers]

**Should Consider**:

1. [Valid medium-priority comments not yet addressed]

**Can Dismiss**:

1. [Invalid/outdated comments with justification]

**Response Suggestions**:

- Reply to addressed comments: "✅ Fixed in [commit sha] - [brief description]"
- Reply to outstanding issues: "[Status update / plan to address / reason not addressing]"
- Reply to invalid comments: "This appears outdated - [explanation]"

---

## Next Steps

1.  [Immediate action item]
2.  [Next action item]

```

```

10. **Cross-Review Analysis (Senior Engineer Meta-Review)**:

    After writing the review file, check for other `PR_REVIEW_*.md` files in the repository root:

    ```bash
    ls -1 PR_REVIEW_*.md 2>/dev/null | grep -v "<current_review_filename>"
    ```

    **If other PR review files exist**:

    a. **Read all existing PR review files** (excluding the one just written)

    b. **Act as a Senior Software Engineer** reviewing the work of junior engineers:
    - Treat all other PR_REVIEW files as reviews written by junior engineers
    - Treat the current review as your own authoritative analysis
    - Apply critical evaluation to all claims and findings

    c. **Perform comparative analysis**:
    - Identify issues raised in other reviews that the current review missed
    - Evaluate the validity of each claim in other reviews
    - Note any false positives or over-reported issues in other reviews
    - Identify consensus findings (issues flagged by multiple reviews)
    - Note conflicting assessments between reviews

    d. **Append a "Cross-Review Analysis" section** to the current PR review file:

    ```markdown
    ---

    ## Cross-Review Analysis (Senior Engineer Meta-Review)

    **Reviews Analyzed**: [count] additional PR review(s) found
    **Review Files**:

    - [list of other PR_REVIEW filenames with timestamps]

    ### Missed Issues from Other Reviews

    [Issues flagged by other reviews that this review did not catch, with evaluation of their validity]

    | Source Review | Issue   | Validity Assessment           | Action Recommended          |
    | ------------- | ------- | ----------------------------- | --------------------------- |
    | PR_REVIEW_xxx | [issue] | Valid/Invalid/Partially Valid | Include/Dismiss/Investigate |

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

    - **[PR_REVIEW_xxx]**: [claim] - **Assessment**: [why this is invalid/overblown]

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

    e. **If no other PR review files exist**:
    - Do not append anything
    - Optionally note to user: "No other PR review files found for cross-analysis"

11. **Report Results**:

    - Save the structured review report to a timestamped file in the repository root directory
    - Output a summary confirmation to the user
    - Provide clear severity counts
    - Give actionable recommendations
    - Suggest review decision (approve/request changes)

    **File Output**:
    - Generate filename: `PR_REVIEW_<timestamp>.md` (e.g., `PR_REVIEW_2025-01-29_143022.md`)
    - Timestamp format: `YYYY-MM-DD_HHMMSS`
    - Write the complete markdown report to this file
    - Confirm to user: `📝 Review saved to PR_REVIEW_<timestamp>.md`

12. **Provide Context-Aware Analysis**:

    - **For Rust**: Focus on ownership/borrowing issues, unsafe code, error handling with Result/Option
    - **For JavaScript/TypeScript**: Focus on type safety, async/await patterns, null/undefined
    - **For Python**: Focus on type hints, exception handling, PEP 8
    - **For SQL**: Focus on injection, indexes, N+1 queries
    - **For API code**: Focus on validation, auth, rate limiting, error responses

13. **Check Against Project Standards**:

    From CLAUDE.md, verify:

    - Naming conventions followed?
    - File organization correct?
    - Error handling patterns consistent?
    - Testing standards met?
    - Documentation requirements satisfied?

## Comment Style Guidelines

When writing comments in the "Summary - All Issues (Quick Reference)" section, follow these principles based on the PR author's demonstrated style:

### Core Principles

1. **Brevity with Precision**: 1-3 sentences maximum. Only exceed when absolutely necessary for clarity.

2. **Collaborative Tone**: Use softening language when appropriate:
   - "I think there's a possible null reference here"
   - "I believe this may cause..."
   - "Can we...?" or "Is it worth...?"
   - "I assume this was..."

3. **Direct Problem Identification**: Be clear and specific about issues:
   - "possible null reference"
   - "infinite render recursion"
   - "race condition"
   - "potential SQL injection"

4. **Question-Driven for Architectural Concerns**: For design decisions, ask questions:
   - "Can we use the factory pattern here like userModel.js does?"
   - "Is it worth setting certain status codes we should not retry?"
   - "Can we just add this to the parts of the JSON that are missing it?"

5. **Provide Context When Needed**: Briefly explain "why" for non-obvious issues:
   - "I think it may be safer to use the factory pattern for this, like `userModel.js` and `upload.js` does."
   - "I believe these are actually generated with `source_merger.py` and shouldn't be edited by hand anyway."

6. **Acknowledge Scope and Tradeoffs**: When appropriate:
   - "Yeah, it's an unfortunate hack, but I believe out of scope for this one."
   - "Unlikely as the edge cases are, it's not expensive to handle them here."

7. **Include Code Suggestions**: When helpful, provide concrete examples:
   ```suggestion
   const userActorDocId = event?.actors?.find((actor) => actor.docType === 'User')?.docId;
   ```

8. **Scale with Complexity**:
   - Simple fixes: Very brief (5-10 words)
   - Security/bugs: 1-2 sentences with clear impact
   - Architecture: 2-4 sentences with reasoning
   - Complex refactoring: Can extend to 5-8 sentences with examples

9. **Professional and Respectful**: Always collaborative, never condescending:
   - "Good catch"
   - "I'd recommend..."
   - "We could..."

10. **Reference Related Context**: When relevant:
    - "Just noticed this from the Copilot comment on #964"
    - "That seems to follow the established pattern more closely"
    - "Like `userModel.js` and `upload.js` does"

### Examples from Actual Reviews

**Simple Validation**:
> I think there's a possible null reference here.

**With Suggested Fix**:
> Since we're getting `receivingAgencyId` from the client, I think it might be a good idea to do a bit of validation on it.

**Guard Against Edge Case**:
> I think this may guard against a possible race completely. As unlikely as it is, I believe a very quick double click could still trigger the race.

**Architectural Pattern**:
> I think it may be safer to use the factory pattern for this, like `userModel.js` and `upload.js` does.

**With Standard Library Suggestion**:
> I think it is actually beneficial to use `urllib` here like was suggested. It's part of standard library, so we don't have to worry about dependency creep. Unlikely as the edge cases are, it's not expensive to handle them here.

**Infinite Loop Concern**:
> I think there's possible infinite render recursion with watching just `roi`.

**Dependency Array Concern**:
> Are all of these really required in the dependency array? This worries me about high potential for unnecessary re-renders.

**Scope Recognition**:
> Yeah, it's an unfortunate hack, but I believe out of scope for this one. I believe it also may have less affect on results returned than it seems.

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

### Java/C#

- Null reference exceptions
- Resource disposal (try-with-resources, using)
- Thread safety
- Collection choices
- Exception hierarchy

## Edge Cases & Error Handling

**No PR Found**:

```
❌ No PR found for current branch

Create a PR first or switch to a branch with an open PR.
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

**PR Comment Analysis Failures**:

```
⚠️  PR Comments Analysis Failed

Unable to fetch PR comments due to:
- [gh CLI not installed / not authenticated / API error]

Continuing with standard code review...
```

**PR Detected but No Comments**:

```
✅ Found PR #[number] but no existing comments/reviews

This is the first review of this PR.
```

**Outdated Review Comments**:

- If comment references old commit_id, note that code may have changed
- Check current code state vs when comment was made
- Mark comments as "potentially outdated" if significant changes occurred

## Context

User-provided arguments: $ARGUMENTS
