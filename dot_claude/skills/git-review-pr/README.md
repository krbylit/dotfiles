# GitHub PR Review Skill

Comprehensive GitHub pull request review using coordinated agent teams.

## What It Does

This skill performs thorough PR reviews by spawning 5 specialized review agents who analyze code from different perspectives (historical validation, current code, security, performance, testing). Agents debate findings to eliminate false positives and reach consensus on severity.

## When It Triggers

### Automatic Activation

- User mentions "review", "PR", or "pull request"
- "Check this code" or "analyze changes"
- Code quality, security, or performance questions

### Manual Invocation

```
/git.review-pr
/git.review-pr-skill
```

## Prerequisites

- GitHub repository with remote
- `gh` CLI installed and authenticated
- Current branch has an open pull request

## How It Works

1. **PR Discovery** - Fetch PR metadata and existing comments
2. **Agent Spawning** - 5 specialized review agents analyze different dimensions
3. **Agent Debate** - Cross-verification of findings with severity calibration
4. **Report Generation** - Consensus review saved to `PR_REVIEW_[timestamp].md`
5. **Recommendation** - Overall assessment (Approve/Request Changes/Block)

## Review Dimensions

- **Historical Validation** - Compare with existing reviews
- **Current Code** - Fresh analysis of all changes
- **Security & Risk** - Injection, XSS, auth bypass, data exposure
- **Performance & Architecture** - Algorithms, queries, patterns
- **Testing & Documentation** - Coverage, edge cases, API docs

## Supporting Files

- **SKILL.md** - Main skill definition with YAML frontmatter
- **README.md** (this file) - Usage guide
- **templates/review-report.md** - Full report template
- **templates/comment-examples.md** - Comment style guide
- **checklists/** - Language-specific review patterns
  - rust.md - Rust ownership, unsafe, Result/Option
  - javascript-typescript.md - Type safety, async patterns
  - python.md - Type hints, PEP 8, exception handling
  - go.md - Error handling, goroutines, interfaces

## Comment Style

Uses collaborative, expert-level comments:

```
✅ Good: "I think there's a possible null reference here."

✅ Good: "Since we're getting this from the client, I think it might
be a good idea to do a bit of validation on it."

❌ Avoid: "This code is wrong and needs to be fixed."
```

See `templates/comment-examples.md` for more examples.

## Example Output

```markdown
# Pull Request Review

**PR**: #123 - Add user authentication
**Recommendation**: ⚠️  Request Changes

## Summary
The authentication implementation is mostly solid but has 2 critical
security issues and 3 performance concerns that should be addressed.

## All Issues (Quick Reference)
🔴 Missing JWT signature validation at handlers/auth.rs:45
🟠 N+1 query in user lookup at services/user_service.rs:78
...

[Detailed sections follow]
```

## Best Practices

1. Skill runs in forked context with general-purpose agent
2. Always checks for existing `PR_REVIEW_*.md` files
3. Cross-references with GitHub PR comments
4. Applies language-specific focus (see checklists/)
5. Balances criticism with positive observations

## Related

- Uses `gh` CLI for GitHub API access
- Coordinates review agents via Task tool
- Saves timestamped reports for historical comparison
