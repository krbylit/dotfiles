# Pull Request Review Template

Use this template structure for all PR review reports.

---

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

1. [Critical fix #1]
2. [Critical fix #2]

### Should Do (Before Merge)

1. [High priority fix #1]
2. [High priority fix #2]

### Could Do (Follow-up)

1. [Medium/Low priority improvements]

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

## Cross-Review Analysis (Senior Engineer Meta-Review)

[Only include this section if other PR_REVIEW_*.md files exist]

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

---

## Next Steps

1. [Immediate action item]
2. [Next action item]
3. [Follow-up action item]
