---
description: Generate comprehensive PR title, description, and checklist from branch changes
allowed-tools: Bash, Read, Write
argument-hint: [optional: --base-branch develop]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command analyzes all changes in the current branch compared to the base branch and generates a comprehensive pull request with title, description, testing checklist, and metadata.

### Execution Steps

1. **Parse Arguments**:
   - Extract base branch from `--base-branch <branch>` if provided
   - If not provided, will auto-detect (see step 2)

2. **Intelligent Base Branch Detection**:

   If `--base-branch` was NOT provided, auto-detect:

   a. **Get current branch**:

   ```bash
   current_branch=$(git rev-parse --abbrev-ref HEAD)
   ```

   b. **Check which standard branches exist**:

   ```bash
   # Check local and remote branches
   git branch --all | grep -E '(develop|main|master)$'
   ```

   c. **Find merge-base with each candidate**:

   ```bash
   # For develop (if exists)
   merge_base_develop=$(git merge-base HEAD develop 2>/dev/null)

   # For main (if exists)
   merge_base_main=$(git merge-base HEAD main 2>/dev/null)

   # For master (if exists)
   merge_base_master=$(git merge-base HEAD master 2>/dev/null)
   ```

   d. **Determine which merge-base is most recent**:

   ```bash
   # Compare commit timestamps to find newest merge-base
   # The branch with the newest merge-base is likely the correct base

   # Get timestamp of each merge-base
   if [ -n "$merge_base_develop" ]; then
     timestamp_develop=$(git show -s --format=%ct $merge_base_develop)
   fi

   if [ -n "$merge_base_main" ]; then
     timestamp_main=$(git show -s --format=%ct $merge_base_main)
   fi

   if [ -n "$merge_base_master" ]; then
     timestamp_master=$(git show -s --format=%ct $merge_base_master)
   fi
   ```

   e. **Select base branch**:
   - **Priority order** (prefer in this order):
     1. `develop` (if merge-base exists and is most recent)
     2. `main` (if merge-base exists and is most recent, or if develop doesn't exist)
     3. `master` (if merge-base exists and is most recent, or if develop/main don't exist)

   - **Validation**:
     - If detected base branch is NOT one of: develop, main, master
     - ERROR: "Cannot auto-detect base branch. Current branch appears to be based on '[detected-branch]'. Please specify base branch explicitly with --base-branch <branch>"
     - List available branches and suggest checking branch configuration

   f. **Report detected base branch**:

   ```
   🔍 Auto-detected base branch: [branch-name]
   📍 Merge-base: [short-sha] ([relative-date])
   ```

   g. **Verification**:

   ```bash
   # Verify the selected base branch exists locally or remotely
   git rev-parse --verify $base_branch 2>/dev/null || \
   git rev-parse --verify origin/$base_branch 2>/dev/null
   ```

   If neither exists: ERROR with helpful message

3. **Verify Git State**:
   - Confirm we're in a git repository
   - Get current branch: `git rev-parse --abbrev-ref HEAD`
   - Verify not on base branch (can't PR from develop to develop)
   - Verify remote is set up for push

4. **Gather Branch Information**:

   ```bash
   # Get commit range
   git log --oneline <base-branch>..HEAD

   # Get file changes
   git diff --stat <base-branch>...HEAD

   # Get detailed diff
   git diff <base-branch>...HEAD

   # Count commits
   git rev-list --count <base-branch>..HEAD

   # Get list of authors
   git log --format='%an' <base-branch>..HEAD | sort -u
   ```

5. **Analyze Changes**:

   **a. Identify Change Type**:
   - Feature (new capability)
   - Bug Fix (fixes issue)
   - Refactoring (restructuring)
   - Performance (optimization)
   - Documentation (docs only)
   - Chore (maintenance, deps)
   - Multiple (mixed changes)

   **b. Categorize File Changes**:
   - Source code changes
   - Test changes
   - Documentation changes
   - Configuration changes
   - Database/migration changes
   - Build/CI changes

   **c. Detect Breaking Changes**:
   - API signature changes
   - Database schema changes
   - Configuration format changes
   - Removed functionality
   - Behavior changes to existing features

   **d. Identify Scope/Area**:
   - Affected modules/components
   - Impacted services (from file paths)
   - Related features

6. **Check for PR Template**:

   Look for PR template in these locations (in order):
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/pull_request_template.md`
   - `docs/PULL_REQUEST_TEMPLATE.md`
   - `PULL_REQUEST_TEMPLATE.md`

   If found:
   - Read template file
   - Parse template structure (sections, comments, placeholders)
   - Use template as base for PR description generation
   - Fill in template sections with generated content
   - Preserve template comments and formatting

   If not found:
   - Use default comprehensive format (defined in step 7)

7. **Read Context**:
   - Read CLAUDE.md for project context
   - Read README.md for project overview
   - Check for related issues/tickets in commit messages

8. **Generate PR Title**:

   **IMPORTANT**: PR title MUST follow conventional commit format. This is not optional.

   **Required Format**: `<type>[optional scope]: <description>`

   **Conventional Commit Types** (choose one):
   - `feat:` - New feature or capability
   - `fix:` - Bug fix
   - `refactor:` - Code restructuring (no behavior change)
   - `perf:` - Performance improvement
   - `docs:` - Documentation only
   - `test:` - Test additions/updates
   - `style:` - Code style/formatting (no logic change)
   - `build:` - Build system or dependencies
   - `ci:` - CI/CD changes
   - `chore:` - Maintenance tasks

   **Optional Scope**: Add scope in parentheses if clear: `feat(auth):`, `fix(api):`, `perf(cache):`

   **Examples** (all following conventional commit format):
   - `feat(auth): add JWT refresh token support`
   - `fix(api): handle null values in person endpoint`
   - `refactor(cache): extract caching logic to service layer`
   - `perf(query): optimize person query with batch loading`
   - `docs(api): update OpenAPI specification`
   - `chore(deps): upgrade Rust to 1.75`
   - `test(person): add cache invalidation tests`

   **Title Requirements**:
   - **MUST use conventional commit format** (`type(scope): description`)
   - ≤72 characters (GitHub limit)
   - Use imperative mood ("Add feature" not "Added feature")
   - Capitalize first word only
   - No period at end
   - Clear and descriptive
   - Captures essence of all changes (if multiple commits)

   **If Multiple Change Types**:
   - Choose the most significant type (feat > fix > refactor > chore)
   - Or use the type that represents the main goal of the PR
   - Example: If PR has feat + tests + docs, use `feat:` as the type

9. **Generate PR Description**:

   **GitHub Markdown Callouts**:
   
   When generating PR descriptions, you MAY use GitHub markdown callouts if they genuinely enhance the content:
   - Available types: `NOTE`, `TIP`, `IMPORTANT`, `WARNING`, `CAUTION`
   - Format: `> [!WARNING]` followed by `> callout text` on subsequent lines
   - **IMPORTANT**: Do NOT overuse callouts or create artificial reasons to include them
   - Only use when they provide genuine value (e.g., highlighting breaking changes, critical security considerations, deployment warnings)
   - Examples of appropriate use:
     - `> [!WARNING]` for breaking changes or critical deployment steps
     - `> [!CAUTION]` for security considerations that must be reviewed
     - `> [!IMPORTANT]` for migration requirements or configuration changes
     - `> [!NOTE]` for helpful context that reviewers should be aware of
     - `> [!TIP]` for testing shortcuts or optimization notes
   - Do NOT use optional titles after `[!CALLOUT]` (GitHub doesn't support them)

   **If PR template exists**, fill it in with generated content:
   - Parse template sections (e.g., ## Summary, ## Changes Made, etc.)
   - For each section:
     - If section asks for summary/overview → Generate 2-4 sentence summary
     - If section asks for changes → List main changes categorized
     - If section asks for reviewer notes → Highlight areas needing attention
     - If section asks for related work → List related PRs/issues
     - If section asks for backlog/notion link → Keep placeholder for user to fill
   - Preserve template structure, comments, and formatting
   - Replace HTML comments with actual content
   - Keep any checkboxes or custom formatting from template
   - Use GitHub callouts sparingly if they add genuine value

   **Example with your template**:

   ```markdown
   ## Summary

   [Generated 2-4 sentence summary of changes and motivation]

   ## Changes Made

   ### Core Changes

   - [Generated list of main changes]

   ### Supporting Changes

   - [Generated list of supporting changes]

   ## Notes to Code Reviewers

   [Generated notes about areas needing special attention, based on change analysis]

   ## Related Work

   [Generated list of related issues, PRs based on commit messages and context]

   ## Backlog Item

   [Notion card](URL) <!-- User fills this in -->
   ```

   **If NO template**, use this comprehensive template structure:

   ````markdown
   ## Summary

   [2-4 sentence summary of what this PR does and why]

   ## Type of Change

   - [ ] 🎯 Feature (new capability)
   - [ ] 🐛 Bug Fix (fixes an issue)
   - [ ] ♻️ Refactoring (code restructuring)
   - [ ] ⚡ Performance (optimization)
   - [ ] 📚 Documentation
   - [ ] 🔧 Chore (maintenance, dependencies)
   - [ ] 💥 Breaking Change

   ## Changes Made

   ### Core Changes

   - [Bulleted list of main changes]
   - [Focus on WHAT changed]

   ### Supporting Changes

   - [Tests added/updated]
   - [Documentation updates]
   - [Configuration changes]

   ## Motivation & Context

   [Explain WHY these changes were needed]
   [Business context or technical reasoning]
   [Link to related issues: Closes #123, Relates to #456]

   ## Breaking Changes

   [If applicable]

   **What breaks**:
   [Description of breaking changes]

   **Migration path**:
   [How to update consuming code/services]

   **Why necessary**:
   [Justification for breaking change]

   ## Implementation Details

   [Technical details for reviewers]

   ### Approach

   [High-level strategy used]

   ### Key Decisions

   - [Important decision #1 and rationale]
   - [Important decision #2 and rationale]

   ### Alternatives Considered

   - [Alternative approach and why rejected]

   ## Testing

   ### Test Coverage

   - [ ] Unit tests added/updated
   - [ ] Integration tests added/updated
   - [ ] Manual testing completed
   - [ ] Edge cases covered

   ### Testing Checklist

   [Specific tests performed]:

   - [ ] [Test scenario 1]
   - [ ] [Test scenario 2]
   - [ ] [Edge case 1]
   - [ ] [Error handling case]

   ### Test Results

   ```bash
   [Output of test run, if available]
   ```
   ````

   ## Performance Impact

   [If applicable]
   - **Before**: [Metric]
   - **After**: [Metric]
   - **Improvement**: [Percentage or description]

   ## Security Considerations

   [If applicable]
   - [Security aspect #1]
   - [Security aspect #2]

   ## Database Changes

   [If applicable]
   - [ ] Migration included
   - [ ] Backward compatible
   - [ ] Rollback plan documented

   ## Deployment Notes

   [Any special deployment considerations]
   - [ ] Environment variables needed
   - [ ] Configuration changes required
   - [ ] Service restart needed
   - [ ] Migration must run before/after deployment

   ## Screenshots/Examples

   [If applicable - UI changes, API responses, etc.]

   ## Checklist

   ### Before Review

   - [ ] Code follows project conventions
   - [ ] All tests pass locally
   - [ ] No linting errors
   - [ ] Documentation updated
   - [ ] Commit messages follow conventional format
   - [ ] Self-review completed

   ### Reviewer Focus Areas

   - [ ] Logic correctness
   - [ ] Error handling
   - [ ] Performance implications
   - [ ] Security considerations
   - [ ] Test coverage

   ## Related PRs

   [If applicable]
   - Depends on: #[PR number]
   - Related: #[PR number]

   ## Additional Context

   [Any other relevant information]

   ***

   /cc @[relevant-reviewers]

   ```

   ```

10. **Customize Based on Change Type**:

    **For Features**:
    - Emphasize new capability and value
    - Include usage examples
    - Document new API endpoints/functions
    - Highlight test coverage

    **For Bug Fixes**:
    - Describe the bug clearly
    - Explain root cause
    - Show fix approach
    - Include regression tests

    **For Refactoring**:
    - Explain motivation (maintainability, performance, etc.)
    - Assure no behavior changes
    - Highlight test coverage proving equivalence

    **For Performance**:
    - Include before/after metrics
    - Explain optimization approach
    - Note any tradeoffs

    **For Breaking Changes**:
    - Clear migration guide
    - Justification for breaking change
    - Deprecation warnings if applicable

11. **Validate PR Title Format**:

    Before providing the final output, validate the generated PR title:

    **Validation Checklist**:
    - [ ] Starts with valid conventional commit type (`feat:`, `fix:`, `refactor:`, etc.)
    - [ ] Optional scope in parentheses comes immediately after type: `type(scope):`
    - [ ] Colon and space separate type from description: `type: description`
    - [ ] Description uses imperative mood
    - [ ] Description is lowercase after the type/scope
    - [ ] No period at end
    - [ ] Total length ≤72 characters
    - [ ] Description is clear and meaningful

    **Regex Pattern** (for reference):

    ```regex
    ^(feat|fix|docs|style|refactor|perf|test|build|ci|chore)(\(.+\))?: .{1,50}$
    ```

    **If validation fails**:
    - Regenerate the title
    - Ensure it strictly follows conventional commit format
    - Do not proceed until title passes all validation checks

12. **REQUIRED: Save PR Description to File**:

    **THIS STEP IS MANDATORY - YOU MUST USE THE Write TOOL TO SAVE THE FILE**

    **File Naming**:
    - Generate filename: `PR_DESC_<timestamp>.md`
    - Timestamp format: `YYYY-MM-DD_HHMMSS`
    - Example: `PR_DESC_2025-01-15_164522.md`

    **File Content**:

    ```markdown
    # Pull Request

    **Title**: <generated-title>

    **Base Branch**: <base-branch>

    **Current Branch**: <current-branch>

    **Generated**: <timestamp>

    ---

    <generated-description>
    ```

    **File Location**:
    - **MUST** save to repository root directory (absolute path)
    - **MUST** use the Write tool to create the file
    - After writing, confirm to user: `📝 PR description saved to PR_DESC_<timestamp>.md`

    **Implementation**:
    
    ```
    Write tool call with:
    - file_path: /absolute/path/to/repo/PR_DESC_<timestamp>.md
    - content: Full PR description with header
    ```

    **DO NOT**:
    - Skip this step
    - Only mention the file without creating it
    - Use bash redirection instead of Write tool
    - Assume the file was created without calling Write

    **Benefits**:
    - Can edit description before creating PR
    - Reference for future PRs
    - Easy to copy/paste into GitHub UI
    - Version control of PR descriptions

13. **Provide GitHub CLI Command**:

    After saving the file, provide the command to create the PR:

    ```bash
    # Push branch
    git push -u origin <current-branch>

    # Create PR with gh CLI
    gh pr create \
      --title "<generated-title>" \
      --body "$(cat <<'EOF'
    <generated-description>
    EOF
    )" \
      --base <base-branch> \
      --reviewer <suggested-reviewers>

    # OR: Use the saved file
    gh pr create \
      --title "<generated-title>" \
      --body-file PR_DESC_<timestamp>.md \
      --base <base-branch> \
      --reviewer <suggested-reviewers>
    ```

    **Note**: The second command variant reads from the saved file, making it easy to edit the description before creating the PR.

## PR Quality Guidelines

### Title Excellence

**CRITICAL**: Every PR title MUST follow conventional commit format.

**Required Format**: `<type>[optional scope]: <description>`

**Valid Types**:

- `feat:` - New feature/capability
- `fix:` - Bug fix
- `refactor:` - Code restructuring (no behavior change)
- `perf:` - Performance improvement
- `docs:` - Documentation only
- `test:` - Test additions/updates
- `style:` - Code style/formatting (no logic change)
- `build:` - Build system or dependencies
- `ci:` - CI/CD changes
- `chore:` - Maintenance tasks

**Be Specific**:

- ❌ `fix: bug fix` (too vague)
- ✅ `fix(auth): handle expired JWT tokens gracefully` (specific, scoped)

**Capture Scope**:

- ❌ `feat: improvements` (vague, no scope)
- ✅ `feat(cache): add Moka caching to person queries` (clear scope and feature)

**Use Imperative Mood**:

- ❌ `feat: added user authentication`
- ✅ `feat: add user authentication`

**Proper Capitalization**:

- ❌ `Feat(Auth): Add JWT Support`
- ✅ `feat(auth): add JWT support`

**No Period**:

- ❌ `fix(api): handle null values.`
- ✅ `fix(api): handle null values`

### Description Excellence

**Summary Should**:

- Explain WHAT and WHY in 2-4 sentences
- Give reviewer context before diving into details
- State the problem being solved
- Preview the solution approach

**Changes Made Should**:

- Be organized by category (Core, Supporting)
- List specific changes, not vague "improvements"
- Help reviewer know what to look for
- Link to related files/components

**Motivation Should**:

- Explain business or technical reasoning
- Provide context for why now
- Link to issues, discussions, or documents
- Help reviewer understand importance

**Implementation Details Should**:

- Highlight key technical decisions
- Explain non-obvious approaches
- Note alternatives considered
- Call out areas needing extra review

**Testing Should**:

- Provide specific test scenarios
- Show coverage of edge cases
- Include test results if significant
- Note any testing limitations

### Checklist Best Practices

**Make It Actionable**:

- ✅ "Verify cache invalidation works correctly"
- ❌ "Check caching"

**Be Comprehensive**:

- Include all test scenarios
- Cover edge cases
- Note security considerations
- Check deployment requirements

**Organize by Priority**:

- Must-test items first
- Nice-to-verify items later
- Group related items

## Examples

### Example 1: Feature PR

````markdown
# PR Title

feat(cache): add Moka caching to person queries

# PR Description

## Summary

This PR adds in-memory caching to the PersonQueryService using Moka, reducing EventStore load and improving query response times from ~200ms to <1ms for cached results. Analytics showed 80% of queries target the same 20% of persons, making caching highly effective.

## Type of Change

- [x] 🎯 Feature (new capability)
- [ ] 🐛 Bug Fix
- [ ] ♻️ Refactoring
- [ ] ⚡ Performance
- [ ] 📚 Documentation
- [ ] 🔧 Chore
- [ ] 💥 Breaking Change

## Changes Made

### Core Changes

- Added Moka cache dependency (v0.12) to Cargo.toml
- Implemented cache-aside pattern in PersonQueryService
- Cache key format: `person:{agency_id}:{person_id}` (prevents cross-tenant access)
- 24-hour TTL for cached projections
- Return `cache_hit: bool` flag in API response for monitoring

### Supporting Changes

- Added unit tests for cache hit/miss scenarios
- Added cache invalidation API: `POST /v1/persons/{id}/cache/invalidate`
- Updated CLAUDE.md with caching strategy documentation
- Updated README.md architecture section

## Motivation & Context

Person queries are the highest-frequency read operation in the system (>10K req/min during peak). Each query currently reads and folds events from EventStore, taking ~200ms average. The data changes infrequently (person summaries update <1% per day), making it ideal for caching.

This change:

- Reduces EventStore CPU load by ~80% (estimated)
- Improves p99 latency from 450ms to <10ms
- Enables scaling to 100K concurrent users without additional EventStore capacity

Closes #234

## Implementation Details

### Approach

Cache-aside pattern: check cache → on miss, read from EventStore → populate cache

### Key Decisions

**Why Moka over Redis**:

- In-memory = no network latency (Redis adds 1-5ms)
- No operational complexity (no separate service to manage)
- Thread-safe, lock-free implementation
- Sufficient for single-instance deployment

**Why 24h TTL**:

- Balances data freshness vs hit rate
- Person data changes <1% per day
- Manual invalidation API available for immediate updates
- Future: Event-based invalidation when person updated

**Why agency_id in cache key**:

- Critical for multi-tenancy security
- Prevents cross-agency cache pollution
- Even bugs won't leak data across tenants

### Alternatives Considered

**Redis caching**: Rejected due to network latency and operational overhead. May revisit when we need multi-instance deployment.

**Longer TTL (7 days)**: Rejected due to data freshness concerns. Current 24h TTL provides 95%+ hit rate per analytics.

## Testing

### Test Coverage

- [x] Unit tests added/updated
- [x] Integration tests added/updated
- [x] Manual testing completed
- [x] Edge cases covered

### Testing Checklist

- [x] Cache hit returns cached data and `cache_hit: true`
- [x] Cache miss reads from EventStore and populates cache
- [x] Cache respects 24h TTL (tested with mock clock)
- [x] Cache invalidation removes entry
- [x] Cache keys include agency_id (multi-tenancy)
- [x] Concurrent access doesn't corrupt cache
- [x] Missing person returns 404, doesn't cache
- [x] EventStore errors don't cache negative results

### Test Results

```bash
$ cargo test person_service
running 8 tests
test test_cache_hit ... ok
test test_cache_miss ... ok
test test_cache_invalidation ... ok
test test_cache_ttl ... ok
test test_concurrent_access ... ok
test test_missing_person_not_cached ... ok
test test_error_not_cached ... ok
test test_multitenant_isolation ... ok

test result: ok. 8 passed; 0 failed
```
````

## Performance Impact

**Before** (no cache):

- p50: 180ms
- p95: 320ms
- p99: 450ms
- EventStore CPU: 45% average

**After** (with cache, 80% hit rate estimated):

- p50: 8ms (96% improvement)
- p95: 35ms (89% improvement)
- p99: 210ms (53% improvement - cache misses + outliers)
- EventStore CPU: 12% average (73% reduction)

Measured on staging with production-like load.

## Security Considerations

- Cache keys include `agency_id` to enforce multi-tenancy
- Cache invalidation endpoint requires valid JWT
- No sensitive data logging in cache operations
- Cache size unbounded (monitoring added, future: max size limit)

## Checklist

### Before Review

- [x] Code follows project conventions
- [x] All tests pass locally
- [x] No linting errors
- [x] Documentation updated (CLAUDE.md, README.md)
- [x] Commit messages follow conventional format
- [x] Self-review completed

### Reviewer Focus Areas

- [ ] Multi-tenancy security (cache key format)
- [ ] Cache invalidation correctness
- [ ] TTL configuration reasonableness
- [ ] Error handling for cache operations
- [ ] Test coverage for edge cases

## Additional Context

Future enhancements (not in this PR):

- Event-based invalidation (subscribe to PersonUpdated events)
- Cache size limits (currently unbounded)
- Cache warming on startup
- Multi-instance cache coordination (when we scale horizontally)

---

/cc @tech-lead @backend-team

````

### Example 2: Bug Fix PR

```markdown
# PR Title
fix(auth): handle missing agency_id in JWT claims

# PR Description

## Summary

Fixes a critical bug where missing or null `agency_id` in JWT claims causes service panic. Now returns 401 Unauthorized with clear error message instead of crashing.

## Type of Change

- [ ] 🎯 Feature
- [x] 🐛 Bug Fix (fixes an issue)
- [ ] ♻️  Refactoring
- [ ] ⚡ Performance
- [ ] 📚 Documentation
- [ ] 🔧 Chore
- [ ] 💥 Breaking Change

## Changes Made

### Core Changes
- Added validation in `middleware/auth.rs` to check for null/missing `agency_id`
- Return 401 Unauthorized instead of panicking
- Added clear error message: "Missing or invalid agency_id in JWT"

### Supporting Changes
- Added unit tests for null and missing `agency_id` scenarios
- Added integration test with malformed JWT
- Updated error logging to capture malformed JWT attempts

## Motivation & Context

**Production Issue**: Service crashed 3 times in the past week when receiving malformed JWTs (likely from client bug or attack attempts).

**Root Cause**: Code assumed `agency_id` would always be present in JWT claims after signature validation, but signature validation doesn't check claim presence, only signature validity.

**Impact**: Service availability (crashes require restart), poor user experience (500 error instead of 401).

Fixes #312

## Implementation Details

### Approach
Added explicit validation after JWT signature check, before extracting claims.

**Before**:
```rust
let agency_id = claims.agency_id.unwrap(); // PANIC if None!
````

**After**:

```rust
let agency_id = claims.agency_id
    .ok_or(AuthError::Unauthorized("Missing or invalid agency_id in JWT"))?;
```

### Root Cause Analysis

JWT library validates signature but doesn't enforce required claims. Our assumption of always-present `agency_id` was incorrect.

## Testing

### Test Coverage

- [x] Unit tests added
- [x] Integration tests added
- [x] Manual testing completed
- [x] Edge cases covered

### Testing Checklist

- [x] Null `agency_id` returns 401
- [x] Missing `agency_id` returns 401
- [x] Empty string `agency_id` returns 401
- [x] Valid `agency_id` works normally
- [x] Error is logged with request ID
- [x] Response follows RFC-7807 ProblemDetails format

### Test Results

```bash
$ cargo test auth_middleware
running 6 tests
test test_valid_jwt ... ok
test test_null_agency_id ... ok
test test_missing_agency_id ... ok
test test_empty_agency_id ... ok
test test_malformed_jwt ... ok
test test_error_logging ... ok

test result: ok. 6 passed; 0 failed
```

## Checklist

### Before Review

- [x] Code follows project conventions
- [x] All tests pass locally
- [x] No linting errors
- [x] Documentation updated
- [x] Commit messages follow conventional format
- [x] Self-review completed

### Reviewer Focus Areas

- [ ] Error handling completeness
- [ ] Edge case coverage
- [ ] Error message clarity
- [ ] Logging appropriateness

Closes #312

```

## Edge Cases & Error Handling

**Not on a Branch**:
- If on detached HEAD, error with instructions
- If on base branch, error (can't PR from main to main)

**No Commits**:
- If current branch has no commits ahead of base
- ERROR: "No commits to include in PR. Make some changes first."

**Uncommitted Changes**:
- Warn user about uncommitted changes
- Ask if they want to commit first or proceed anyway
- Option to run `/commit-atomic` first

**Very Large PR**:
- If >1000 lines changed, warn about reviewability
- Suggest breaking into smaller PRs
- Provide guidance on splitting

**No Base Branch**:
- If specified base branch doesn't exist
- List available branches
- Suggest correct base branch

## CRITICAL REQUIREMENTS

**YOU MUST:**

1. **Generate** the complete PR title and description
2. **Call the Write tool** to save `PR_DESC_<timestamp>.md` to the repository root
3. **Confirm** the file was saved by showing the filename to the user
4. **Provide** the gh CLI commands for creating the PR

**DO NOT** skip step 2. The Write tool call is **mandatory and non-negotiable**.

## Context

User-provided arguments: $ARGUMENTS

## Notes

- PR description should be **comprehensive yet scannable**
- Use checkboxes for easy review tracking
- Include all information reviewers need
- Link to related issues/PRs
- Provide specific test scenarios
- Call out areas needing extra scrutiny
- Make it easy for reviewers to understand context
- Think about what questions reviewers will have and answer them preemptively
```