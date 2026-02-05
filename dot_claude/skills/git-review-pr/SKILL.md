# GitHub Pull Request Review Skill

## Metadata

**Name**: GitHub PR Review
**Version**: 1.0.0
**Category**: git, code-review, quality-assurance
**Tags**: pr, pull-request, review, github, code-quality, security, performance

## Description

Performs comprehensive code review of GitHub pull requests, analyzing for bugs, security vulnerabilities, performance issues, maintainability concerns, and adherence to project standards. Evaluates existing PR comments and cross-references with current findings.

## Invocation

### Automatic Triggers

This skill automatically activates when:
- User mentions "review", "PR", or "pull request" in context of current branch
- User asks to "check" or "analyze" code changes
- User wants to "evaluate" or "assess" a PR
- Conversation involves code quality, security review, or performance analysis of a PR

### Manual Invocation

Can also be explicitly invoked with slash commands:
- `/git.review-pr-skill` - Invoke the skill explicitly
- `/git.review-pr` - Legacy command (original command-based implementation)

Use manual invocation when you want to force a review even if context doesn't clearly indicate it.

## Prerequisites

- GitHub repository with remote
- `gh` CLI installed and authenticated
- Current branch has an associated open pull request
- Git repository with commit history

## Capabilities

This skill enables Claude to:
1. **Detect and validate** pull requests for the current branch
2. **Fetch existing feedback** from PR comments and reviews
3. **Analyze changes** across multiple quality dimensions:
   - Correctness & bugs (logic errors, edge cases, error handling)
   - Security vulnerabilities (injection, XSS, auth bypass, data exposure)
   - Performance issues (inefficient algorithms, N+1 queries, blocking ops)
   - Maintainability (code clarity, complexity, duplication, naming)
   - Best practices (language idioms, framework patterns, SOLID principles)
   - Testing coverage (edge cases, error paths, test quality)
   - Documentation completeness (API docs, breaking changes, examples)
4. **Categorize findings** by severity (Critical/High/Medium/Low)
5. **Evaluate existing PR comments** for validity and addressed status
6. **Cross-reference reviews** to identify consensus and missed issues
7. **Generate structured reports** with actionable recommendations

## Workflow

### Phase 1: PR Discovery & Validation

1. Verify `gh` CLI availability
2. Confirm GitHub remote exists
3. Detect PR for current branch
4. Fetch PR metadata (number, title, author, base/head branches, URL, state)

### Phase 2: Context Gathering

1. Fetch existing PR comments (line-specific review comments)
2. Fetch general PR discussion comments
3. Fetch PR reviews (approve/request changes/comment)
4. Update branches to latest (base and head)
5. Gather diff and commit history from base branch

### Phase 3: Project Context Analysis

1. Read project documentation (CLAUDE.md, README.md)
2. Identify language/framework from file extensions
3. Note code patterns and conventions
4. Check for configuration files (.editorconfig, .prettierrc, etc.)

### Phase 4: Multi-Dimensional Code Review

For each changed file, analyze across dimensions:

**🐛 Correctness & Bugs**
- Logic errors, off-by-one errors
- Null/undefined handling, edge cases
- Type mismatches, resource leaks
- Race conditions, deadlock potential

**🔒 Security**
- SQL/XSS/Command injection
- Path traversal, auth bypass
- Sensitive data exposure
- Input validation, output encoding

**⚡ Performance**
- Inefficient algorithms (O(n²) → O(n))
- Database N+1 queries
- Blocking ops in async code
- Missing caching opportunities

**🔧 Maintainability**
- Code clarity, function length
- Cyclomatic complexity, duplication
- Naming, magic numbers
- Modularity, testability

**✨ Best Practices**
- Language idioms, framework patterns
- Project-specific patterns (from CLAUDE.md)
- SOLID principles, error handling
- Logging, configuration management

**🧪 Testing**
- Test coverage for new code
- Edge cases, error paths
- Test quality and clarity

**📚 Documentation**
- Public API documentation
- Complex logic explanations
- Breaking change notes

### Phase 5: Severity Classification

- **🔴 CRITICAL**: Security vulnerabilities, data corruption, crashes, breaking changes
- **🟠 HIGH**: Likely bugs, performance issues, poor error handling
- **🟡 MEDIUM**: Potential bugs, minor performance issues, missing tests
- **🟢 LOW**: Style issues, minor naming improvements, optimizations

### Phase 6: PR Comment Evaluation

For each existing PR comment:
1. Read current code at flagged location
2. Assess validity (still applicable / addressed / outdated / partially valid)
3. Verify if fixes were applied correctly
4. Cross-reference with current review findings
5. Categorize as: Consensus / Addressed / Outstanding / Questionable

### Phase 7: Report Generation

Generate structured markdown report with:
- PR metadata and summary
- Overall assessment and recommendation
- **All Issues (Quick Reference)** - concise, expert-level comments for each issue
- Detailed issue sections by severity with code examples
- Positive observations
- Testing and documentation gaps
- Security and performance notes
- Existing PR comments analysis (addressed/outstanding/consensus/questionable)
- Cross-review analysis if other review files exist
- Actionable next steps

Save to timestamped file: `PR_REVIEW_<YYYY-MM-DD_HHMMSS>.md`

### Phase 8: Cross-Review Meta-Analysis

If other `PR_REVIEW_*.md` files exist:
1. Read all existing review files
2. Act as Senior Engineer evaluating all reviews
3. Identify missed issues, consensus findings, conflicting assessments
4. Evaluate validity of claims in other reviews
5. Append cross-review analysis section to current report

## Comment Style Guidelines

When writing review comments, follow these principles:

### Core Principles

1. **Brevity with Precision**: 1-3 sentences maximum
2. **Collaborative Tone**: Use softening language ("I think...", "I believe...", "Can we...?")
3. **Direct Problem Identification**: Be specific ("possible null reference", "race condition")
4. **Question-Driven for Architecture**: Ask questions for design decisions
5. **Provide Context**: Briefly explain "why" for non-obvious issues
6. **Acknowledge Tradeoffs**: Note scope limitations when appropriate
7. **Include Code Suggestions**: Provide concrete examples when helpful
8. **Scale with Complexity**: Simple fixes = brief; complex issues = detailed
9. **Professional and Respectful**: Always collaborative, never condescending
10. **Reference Related Context**: Link to similar patterns in codebase

### Examples

**Simple Validation**:
> I think there's a possible null reference here.

**With Suggested Fix**:
> Since we're getting `receivingAgencyId` from the client, I think it might be a good idea to do a bit of validation on it.

**Guard Against Edge Case**:
> I think this may guard against a possible race completely. As unlikely as it is, I believe a very quick double click could still trigger the race.

**Architectural Pattern**:
> I think it may be safer to use the factory pattern for this, like `userModel.js` and `upload.js` does.

## Language-Specific Focus

### Rust
- Ownership/borrowing, unsafe code, Result/Option
- Panic potential, unnecessary clones
- Concurrency (Send/Sync, data races)

### JavaScript/TypeScript
- Type safety (any usage), null/undefined
- Async/await patterns, promise error handling
- Memory leaks (closures, event listeners)

### Python
- Type hints, exception handling, PEP 8
- List comprehensions, generators, context managers

### Go
- Error handling (nil checks), goroutine leaks
- Channel deadlocks, defer usage, interface design

### Java/C#
- Null reference exceptions, resource disposal
- Thread safety, collection choices

## Error Handling

**No PR Found**:
```
❌ No PR found for current branch

Create a PR first or switch to a branch with an open PR.
```

**Very Large Changes** (>1000 lines):
- Warn about thoroughness limitations
- Suggest breaking into smaller reviews
- Focus on most critical files first

**Auto-Generated Code**:
- Detect auto-generated files (headers, build output)
- Apply lighter review standards
- Focus on how generated code is used

**PR Comment Analysis Failures**:
```
⚠️  PR Comments Analysis Failed

Unable to fetch PR comments due to:
- [specific error reason]

Continuing with standard code review...
```

## Examples

### Example 1: User asks for PR review
**User**: "Can you review my PR?"

**Skill activation**: Auto-triggered (mentions "review" + "PR")

**Claude**:
1. Detects PR #123 for current branch
2. Fetches 5 existing comments and 2 reviews
3. Updates branches to latest
4. Analyzes 8 changed files across all dimensions
5. Finds: 1 critical (security), 2 high (bugs), 5 medium, 3 low
6. Evaluates existing comments: 3 addressed, 2 outstanding
7. Generates comprehensive report: `PR_REVIEW_2026-02-04_143022.md`
8. Provides summary with recommendation to request changes

### Example 2: Security-focused review
**User**: "Check this PR for security issues"

**Skill activation**: Auto-triggered ("check" + "PR" + "security")

**Claude**:
1. Standard PR detection and context gathering
2. **Extra emphasis** on security dimension during review
3. Deep analysis of: injection vectors, auth flows, data exposure, input validation
4. Highlights security findings prominently in report
5. Provides specific remediation code examples

### Example 3: Performance review
**User**: "Is this PR performant?"

**Skill activation**: Auto-triggered ("PR" + "performant")

**Claude**:
1. Standard workflow with focus on performance dimension
2. Analyzes: algorithm complexity, database queries, caching, blocking operations
3. Benchmarks critical code paths conceptually
4. Suggests optimizations with code examples

## Best Practices

1. **Read files before analyzing**: Always read changed files in full context
2. **Check project standards**: Reference CLAUDE.md for project-specific patterns
3. **Be specific with examples**: Show problematic code + suggested fix
4. **Balance criticism**: Note positive observations alongside issues
5. **Explain impact**: Always state "why" an issue matters
6. **Language-appropriate**: Apply language-specific lens to review
7. **Cross-reference comments**: Don't duplicate issues already flagged by others
8. **Trust but verify**: Check if flagged issues are actually fixed
9. **Senior perspective**: Apply critical thinking to all claims (including other reviews)

## Resources

- Review report template: `./templates/review-report.md`
- Comment style guide: `./templates/comment-examples.md`
- Language-specific checklists: `./checklists/`

## Notes

- This skill replaces manual `/git.review-pr` command invocation with automatic triggering
- Can still be explicitly invoked with `/git.review-pr` if preferred
- Report files accumulate in repo root - consider archiving old reviews
- Cross-review analysis provides meta-level quality assurance across multiple reviews
- Skill adapts review depth based on change size and complexity
