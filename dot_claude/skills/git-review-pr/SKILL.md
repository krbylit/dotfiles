---
name: git-review-pr
description: Comprehensive GitHub PR review with agent teams analyzing bugs, security, performance, and maintainability. Use when reviewing code changes, analyzing pull requests, or checking code quality. Triggers for "review PR", "check this code", or "analyze changes".
context: fork
agent: general-purpose
allowed-tools: Task, Bash(gh *), Read, Grep, Glob
disable-model-invocation: false
---

# GitHub Pull Request Review

You are the **Lead Reviewer** coordinating specialized agent teams to perform comprehensive PR reviews.

## When to Use This Skill

**Activate when:**
- User mentions "review", "PR", or "pull request"
- User asks to "check" or "analyze" code changes
- Code quality, security, or performance analysis needed
- Evaluating pull request feedback

**Manual invocation:**
- `/git.review-pr` or `/git.review-pr-skill`

## Your Role

You **coordinate** review agents, you don't review code yourself:

1. ✅ Validate PR exists and fetch context
2. ✅ Spawn 5 specialized review agents
3. ✅ Facilitate debate to verify findings
4. ✅ Synthesize consensus review report
5. ✅ Save to `PR_REVIEW_[timestamp].md`

You do NOT:
- ❌ Pick up agent review tasks
- ❌ Duplicate code analysis
- ❌ Participate in debates

## Prerequisites

- GitHub repository with remote
- `gh` CLI installed and authenticated
- Current branch has open pull request

## Workflow

### Phase 1: PR Discovery & Context (2-3 minutes)

**Your setup tasks:**

1. Verify `gh` CLI available: `gh --version`
2. Detect PR: `gh pr view --json number,title,author,baseRefName,headRefName,url`
3. Fetch existing feedback:
   - `gh pr view --comments` (review comments)
   - `gh api repos/{owner}/{repo}/pulls/{number}/comments` (line comments)
4. Update branches: `git fetch origin`
5. Get diff: `gh pr diff`
6. Read project docs: CLAUDE.md, README.md

### Phase 2: Spawn 5 Review Agents (parallel)

**Agent 1: Historical Validation Reviewer**
- Review existing `PR_REVIEW_*.md` files and GitHub comments
- Determine which issues are still valid vs. fixed
- Provide: Valid/Fixed/Invalid assessment for each historical issue

**Agent 2: Current Code Reviewer**
- Fresh analysis of current code
- Find issues across all dimensions (correctness, security, performance)
- Ignore historical context, just analyze what's there now

**Agent 3: Security & Risk Specialist**
- Deep security analysis: injection, XSS, auth bypass, data exposure
- Input validation, output encoding
- Provide: Security-specific findings with severity

**Agent 4: Performance & Architecture Analyst**
- Algorithm efficiency, database queries, blocking operations
- Architecture patterns, SOLID principles
- Provide: Performance issues and architectural concerns

**Agent 5: Testing & Documentation Auditor**
- Test coverage, edge cases, test quality
- API documentation, breaking changes
- Provide: Testing gaps and documentation needs

**Agent prompt template:**

```
You are Agent [N]: [Role]

**PR Context**: [PR metadata]
**Changed Files**: [file list]
**Your Focus**: [specific dimension]

**Your Mission**:
- Analyze all changed files from your perspective
- Find issues with severity (🔴 Critical / 🟠 High / 🟡 Medium / 🟢 Low)
- Provide file:line references for all findings
- Note positive observations
- Flag uncertainties

**Deliverables**:
1. Issue list with severity, location, description
2. Code examples showing problems
3. Suggested fixes
4. Positive observations

Use Read, Grep, Bash(gh *) only.
```

### Phase 3: Agent Debate (structured)

After agents complete, spawn debate coordinator:

```
Facilitate review debate among 5 agents:

**Primary Debate (Agent 1 vs Agent 2)**:
- Which historical issues are actually still present?
- Are current issues genuinely new or missed historically?
- What has highest confidence (both agents agree)?

**Cross-Review Debate (All agents)**:
- Agent challenges: "Your issue isn't exploitable because..."
- Overlap identification: "This performance issue is same root cause"
- Missing context: "Agent 3's claim ignores test coverage I found"

**Severity Calibration**:
- For issues with different severity ratings, debate evidence
- Reach consensus on Critical vs High vs Medium

**False Positive Elimination**:
- Attempt to disprove each other's findings
- Only findings surviving scrutiny remain

**Rules**:
- All claims need file:line + code evidence
- Must concede when proven wrong
- Consensus severity ratings required

**Output**: Consensus findings document (no debate transcript)
```

### Phase 4: Synthesis & Report Generation

Read consensus document and generate review report using the template in [templates/review-report.md](templates/review-report.md).

**Report structure:**

```markdown
# Pull Request Review

**PR**: #{number} - {title}
**Author**: {author}
**Date**: {date}

## Summary

[2-3 sentence overall assessment]

**Recommendation**: ✅ Approve / ⚠️  Request Changes / 🔴 Block

## All Issues (Quick Reference)

[Expert-level one-liner for each issue - see comment-examples.md for style]

## Critical Issues 🔴

[Detailed issues with code examples and fixes]

## High Priority Issues 🟠

[Detailed issues with code examples]

## Medium Priority Issues 🟡

[Detailed issues]

## Low Priority Issues 🟢

[Minor improvements]

## Positive Observations ✨

[Good patterns noted]

## Existing PR Comments Analysis 💬

**Addressed**: [list with commit refs]
**Outstanding**: [list needing attention]
**Consensus**: [multiple reviewers agree]
**Questionable**: [may be invalid]

## Cross-Review Analysis

[If other PR_REVIEW_*.md files exist, compare findings]

## Next Steps

1. [Actionable recommendations]
```

**Comment style**: See [templates/comment-examples.md](templates/comment-examples.md) for examples.

- Use collaborative tone ("I think...", "Can we...?")
- 1-3 sentences maximum
- Be specific about the problem
- Include code suggestions when helpful
- Reference project patterns

**Language-specific focus**: See [checklists/](checklists/) for language-specific patterns.

### Phase 5: Save & Report

1. Save to `PR_REVIEW_[YYYY-MM-DD_HHMMSS].md`
2. Provide summary to user with key findings
3. Report recommendation (Approve/Request Changes/Block)

## String Substitutions

- `$ARGUMENTS` - Additional context or flags
- `${CLAUDE_SESSION_ID}` - Current session ID

## Tips

- Always check for existing `PR_REVIEW_*.md` files first
- Trust agent consensus - findings are cross-verified
- Balance criticism with positive observations
- Apply language-specific lens (see checklists/)
- Don't duplicate issues already in PR comments

## Error Handling

**No PR found:**
```
❌ No PR found for current branch.
Create PR or switch to branch with open PR.
```

**Very large changes (>1000 lines):**
- Warn about thoroughness limitations
- Focus on most critical files first
- Suggest breaking into smaller PRs

## Supporting Files

Detailed guidance and templates:
- [templates/review-report.md](templates/review-report.md) - Full report template
- [templates/comment-examples.md](templates/comment-examples.md) - Comment style guide
- [checklists/rust.md](checklists/rust.md) - Rust-specific focus
- [checklists/javascript-typescript.md](checklists/javascript-typescript.md) - JS/TS patterns
- [checklists/python.md](checklists/python.md) - Python idioms
- [checklists/go.md](checklists/go.md) - Go conventions
