# Git PR Review Skill

Comprehensive code review skill for GitHub pull requests that analyzes code across multiple quality dimensions and provides structured, actionable feedback.

## Overview

This skill performs deep analysis of PRs including:
- **Code correctness** (bugs, edge cases, error handling)
- **Security vulnerabilities** (injection, XSS, auth bypass, data exposure)
- **Performance issues** (inefficient algorithms, N+1 queries, blocking ops)
- **Maintainability** (code clarity, complexity, duplication)
- **Best practices** (language idioms, framework patterns)
- **Testing coverage** (edge cases, error paths)
- **Documentation completeness** (API docs, breaking changes)

Additionally analyzes existing PR comments to identify addressed issues, outstanding concerns, and cross-references findings across multiple reviews.

## Invocation Methods

### Auto-Activation

The skill automatically activates when you:
- Mention "review", "PR", or "pull request"
- Ask to "check" or "analyze" code changes
- Want to "evaluate" or "assess" a PR
- Discuss code quality, security, or performance in PR context

### Manual Invocation

You can explicitly invoke with slash commands:

```bash
/git.review-pr-skill         # Invoke the skill
/git.review-pr-skill [args]  # With optional focus areas
```

**Legacy command** (original implementation):
```bash
/git.review-pr
```

## Prerequisites

1. GitHub repository with remote
2. `gh` CLI installed and authenticated
3. Current branch has an associated open PR

## Output

Generates timestamped markdown report: `PR_REVIEW_<YYYY-MM-DD_HHMMSS>.md`

Report includes:
- Executive summary with overall assessment
- **All Issues (Quick Reference)** section with concise, expert-level comments
- Detailed issue analysis by severity (Critical/High/Medium/Low)
- Positive observations
- Testing and documentation gaps
- Existing PR comments analysis (addressed/outstanding/consensus/questionable)
- Cross-review meta-analysis (if other reviews exist)
- Actionable next steps

## Language Support

Optimized review patterns for:
- **Rust**: Ownership/borrowing, unsafe code, Result/Option
- **JavaScript/TypeScript**: Type safety, async/await, null/undefined
- **Python**: Type hints, exception handling, PEP 8
- **Go**: Error handling, goroutines, nil checks
- **Java/C#**: Null exceptions, resource disposal, thread safety

## Resources

- `SKILL.md` - Main skill definition with triggers and workflow
- `templates/review-report.md` - Structured report template
- `templates/comment-examples.md` - Style guide with examples
- `checklists/*.md` - Language-specific review checklists

## Features

### Existing PR Comment Analysis
- Fetches all review comments, general comments, and PR reviews
- Determines which issues have been addressed vs still outstanding
- Identifies consensus issues (flagged by multiple reviewers)
- Spots questionable/outdated comments
- Provides reviewer agreement statistics

### Cross-Review Meta-Analysis
- Detects other `PR_REVIEW_*.md` files in repo
- Acts as Senior Engineer evaluating all reviews
- Identifies missed issues, consensus findings, conflicting assessments
- Evaluates validity of claims across reviews
- Provides consolidated recommendations with confidence level

### Comment Style
- Collaborative tone ("I think...", "Can we...?")
- Specific problem identification
- Context and impact explanation
- Code suggestions when helpful
- Appropriate detail level based on issue complexity

## Examples

### Basic Review
```
User: Can you review my PR?
Claude: [Activates git-review-pr skill, generates comprehensive report]
```

### Security-Focused
```
User: Check this PR for security issues
Claude: [Emphasizes security dimension in analysis]
```

### Performance Review
```
User: Is this PR performant?
Claude: [Focuses on performance analysis]
```

## Notes

- Report files accumulate in repo root - consider archiving old reviews
- Cross-review analysis provides quality assurance across multiple reviews
- Skill adapts depth based on change size and complexity
- Always reads project standards (CLAUDE.md) when available
