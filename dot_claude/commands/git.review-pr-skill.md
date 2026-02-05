---
description: Review the current branch's pull request using the comprehensive PR review skill
allowed-tools: All
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Instructions

Execute the **git-review-pr** skill to perform a comprehensive code review of the pull request associated with the current branch.

The skill will:
1. Detect and validate the PR for the current branch
2. Fetch existing PR comments and reviews
3. Analyze changes across multiple quality dimensions (bugs, security, performance, maintainability, best practices, testing, documentation)
4. Evaluate existing PR comments for validity
5. Generate a structured review report with actionable recommendations
6. Perform cross-review meta-analysis if other review files exist

The skill uses language-specific review patterns and adapts depth based on change complexity.

**Note**: This command explicitly invokes the git-review-pr skill. The skill can also be automatically triggered by mentioning PR reviews in conversation.

## Execution

Follow the complete workflow defined in `~/.claude/skills/git-review-pr/SKILL.md`:

1. **Phase 1: PR Discovery & Validation** - Verify gh CLI, detect PR, fetch metadata
2. **Phase 2: Context Gathering** - Fetch comments, reviews, update branches, gather diffs
3. **Phase 3: Project Context Analysis** - Read CLAUDE.md, README, identify patterns
4. **Phase 4: Multi-Dimensional Code Review** - Analyze correctness, security, performance, maintainability, best practices, testing, documentation
5. **Phase 5: Severity Classification** - Categorize as Critical/High/Medium/Low
6. **Phase 6: PR Comment Evaluation** - Assess validity of existing comments
7. **Phase 7: Report Generation** - Create structured markdown report: `PR_REVIEW_<timestamp>.md`
8. **Phase 8: Cross-Review Meta-Analysis** - Compare with other review files if they exist

Apply language-specific focus from:
- `~/.claude/skills/git-review-pr/checklists/rust.md`
- `~/.claude/skills/git-review-pr/checklists/javascript-typescript.md`
- `~/.claude/skills/git-review-pr/checklists/python.md`
- `~/.claude/skills/git-review-pr/checklists/go.md`

Use comment style guidelines from:
- `~/.claude/skills/git-review-pr/templates/comment-examples.md`

Use report template from:
- `~/.claude/skills/git-review-pr/templates/review-report.md`

**User Arguments**: If the user provided arguments ($ARGUMENTS), consider them as additional focus areas or specific concerns to emphasize in the review.
