---
description: Stage and commit all uncommitted changes in atomic, logically grouped commits with conventional commit messages
allowed-tools: Bash, Read
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command analyzes all uncommitted changes in the repository, groups them into logical, atomic commits, and creates conventional commit messages for each group.

### Execution Steps

1. **Verify Git Repository**:
   - Confirm we're in a git repository
   - Check for uncommitted changes
   - If no changes exist, report and exit

2. **Check for Staged Changes**:
   - Run `git diff --cached --name-only` to check for staged files
   - If staged changes exist:
     - **Skip to step 4** (commit staged changes only)
     - Do NOT group changes - user has already grouped them
   - If no staged changes:
     - Continue to step 3 (analyze and group all changes)

3. **Analyze Changes** (only if no staged changes):
   - Run `git status --porcelain` to get all modified/new files
   - Run `git diff` for unstaged changes
   - Read the actual changes to understand their nature

4. **Group Changes Logically** (only if no staged changes):
   - Analyze file paths and change contents
   - Group related changes that should be committed together:
     - Same feature/functionality
     - Same file or related files
     - Same conceptual change
     - Dependencies between changes
   - Each group should be independently meaningful
   - Separate distinct features/fixes/refactors into different groups

5. **For Each Logical Group** (or for staged changes if they exist):

   a. **Generate Commit Message**:
   - Analyze what changed and why (from code context)
   - Determine conventional commit type:
     - `feat:` - New feature/capability
     - `fix:` - Bug fix
     - `refactor:` - Code restructuring (no behavior change)
     - `docs:` - Documentation only
     - `test:` - Test additions/updates
     - `style:` - Formatting (no logic change)
     - `perf:` - Performance improvement
     - `build:` - Build system/dependencies
     - `ci:` - CI/CD changes
     - `chore:` - Maintenance tasks

   - Add optional scope in parentheses if clear: `feat(auth):`, `fix(api):`

   - Create subject line (imperative mood, ≤50 chars):
     - Start with verb: "Add", "Fix", "Update", "Remove", "Refactor"
     - Capitalize first word
     - No period at end
     - Focus on WHAT changed
     - Examples:
       - `feat(cache): add Moka caching to person queries`
       - `fix(validation): handle null agency_id in JWT`
       - `refactor(handlers): extract common error handling`
       - `docs(api): update OpenAPI spec for person endpoint`

   - Decide if body is needed:
     - **Include body ONLY if**:
       - The WHY is not obvious from the code changes
       - Complex reasoning or tradeoffs involved
       - Important context about broader codebase impact
       - Breaking changes need explanation
     - **Do NOT include body for**:
       - Routine changes where code is self-explanatory
       - Simple feature additions
       - Obvious bug fixes
       - Standard refactoring

   - If body is needed:
     - Focus on WHY, not WHAT (code shows what)
     - Explain reasoning in context of broader codebase
     - Keep concise (2-4 sentences usually sufficient)
     - One blank line after subject
     - Wrap at 72 characters per line
     - Example:

       ```
       feat(cache): add Moka caching to person queries

       Person queries are high-frequency and read-only projections that
       rarely change. Caching improves response time and reduces EventStore
       load, which is critical as the user base scales.
       ```

   - Add footer if needed:
     - `Refs: #123` for issue references
     - `BREAKING CHANGE:` for breaking changes
     - `Reviewed-by:` if applicable

   b. **Stage Files** (skip if changes already staged):
   - If processing unstaged changes: `git add <files in this group>`
   - If changes already staged: Skip (files already staged by user)

   c. **Create Commit**:
   - Use heredoc for proper formatting:

     ```bash
     git commit -m "$(cat <<'EOF'
     feat(cache): add Moka caching to person queries

     Person queries are high-frequency and read-only projections that
     rarely change. Caching improves response time and reduces EventStore
     load, which is critical as the user base scales.
     EOF
     )"
     ```

   - Verify commit succeeded

6. **Report Results**:
   - Number of commits created
   - List each commit with:
     - Commit hash (short)
     - Commit message subject
     - Files included
   - Suggest next steps (push, review, etc.)

## Commit Message Quality Guidelines

### Imperative Mood

Use imperative verb form (command form) as if giving an order:

- ✅ "Add caching to person service"
- ✅ "Fix null pointer in auth middleware"
- ✅ "Update API documentation"
- ❌ "Added caching to person service"
- ❌ "Fixed null pointer"
- ❌ "Updating documentation"

**Why**: Git's own messages use imperative ("Merge branch", "Revert commit"), and it reads naturally: "If applied, this commit will [your subject line]"

### Subject Line Excellence

**Length**: Maximum 50 characters (hard limit)

**Strategies for brevity**:

- Remove unnecessary words ("the", "a", "an")
- Use abbreviations for long module names
- Focus on essential action + target
- ✅ `feat(cache): add person query caching`
- ❌ `feat(cache): add caching functionality to the person query service`

**Capitalization**: Only first word

- ✅ `feat(auth): add JWT validation middleware`
- ❌ `Feat(Auth): Add JWT Validation Middleware`

**No period**: Subject lines don't end with periods

- ✅ `fix(api): handle missing agency_id`
- ❌ `fix(api): handle missing agency_id.`

### When to Include Body

**INCLUDE body when**:

1. **Non-obvious reasoning**: Why this approach over alternatives?

   ```
   refactor(query): use event folding instead of snapshots

   Snapshots add complexity and can drift out of sync with events.
   Event folding is slower but guarantees consistency and simplifies
   the projection model, which is more important at our current scale.
   ```

2. **Broader context**: How does this fit into larger system?

   ```
   feat(audit): log all queries to agency-specific streams

   Multi-tenancy compliance requires per-agency audit trails. Using
   separate streams enables tenant-specific retention policies and
   simplifies GDPR data deletion requests.
   ```

3. **Breaking changes**: What breaks and why?

   ```
   refactor(api)!: change person endpoint response format

   BREAKING CHANGE: PersonSummary now includes nested address object
   instead of flat fields. This aligns with the canonical data model
   and simplifies future schema evolution.
   ```

4. **Complex tradeoffs**: What did you sacrifice and why?

   ```
   perf(cache): reduce TTL to 6 hours from 24 hours

   Balancing cache hit rate against data freshness. Analytics show
   most queries are within 1-hour windows, so 6-hour TTL maintains
   90% hit rate while improving data currency for edge cases.
   ```

**OMIT body when**:

1. **Self-explanatory code**: Change is obvious from diff

   ```
   feat(api): add health check endpoint
   ```

2. **Standard patterns**: Following established conventions

   ```
   test(person): add cache invalidation tests
   ```

3. **Simple fixes**: Bug fix is straightforward

   ```
   fix(validation): check for empty string agency_id
   ```

4. **Documentation updates**: Changes speak for themselves

   ```
   docs(readme): update installation instructions
   ```

### Body Content Guidelines

**Focus on WHY**:

- Why was this change necessary?
- Why this approach over alternatives?
- Why does this matter in the broader codebase context?

**Code-level reasoning**:

- Architecture considerations
- Performance implications
- Maintainability tradeoffs
- Data consistency requirements
- Security/compliance needs

**NOT about**:

- Ticket descriptions (code tells the story)
- What changed (diff shows this)
- How to use the feature (docs explain this)
- Implementation details (code demonstrates this)

**Example - Good body**:

```
feat(projection): add MongoDB projection client

Multi-phase migration from EventStore to MongoDB for projections.
MongoDB enables pre-materialized views and faster queries, critical
for supporting 10K+ concurrent users. KurrentClient remains for Phase 1,
both clients implement ProjectionClient for zero-code migration path.
```

**Example - Bad body**:

```
feat(projection): add MongoDB projection client

This commit adds a new MongoProjectionClient class that implements the
ProjectionClient interface. It has methods for reading projections and
connecting to MongoDB. The implementation uses the official MongoDB Rust
driver and includes error handling for connection failures.
```

Example - Bad body (far too long and redundant):

```
docs: add comprehensive implementation plan for Rust rewrite

Create detailed phase-by-phase implementation plan for leads-queries
service rewrite in Rust using service layer architecture:

**Structure:**
- Phase 0: Repository scaffolding (2 hours)
- Phase 1: Infrastructure layer (8 hours)
- Phase 2: Domain layer (10 hours)
- Phase 3: HTTP & API layer (8 hours)
- Phase 4: Application wiring (6 hours)
- Phase 5: Schema integration (4 hours)
- Phase 6: Documentation & polish (4 hours)

**Total Estimate:** 42 hours (~5-6 days)

**Key Components:**
- ProjectionClient trait for KurrentDB/MongoDB abstraction
- PersonQueryService and OperationQueryService
- QueryAuditor for logging to query-journal streams
- REST endpoints: GET /v1/persons/{id}, /v1/operations/{id}
- Multi-tenancy via JWT validation
- QueryEnvelope audit logging
- Moka-based caching for PersonSummary queries

**Deliverables:**
- Complete file checklist (60+ files)
- Testing strategy (unit, integration, load tests)
- Success criteria (functional, non-functional, technical)
- Risk mitigation strategies
- Deployment plan
- Monitoring & observability setup

Based on design document in:
01_Projects/task_2_leads_queries_setup/leads_queries_final_design.md

Ref: Task 2 (leads-queries setup)
```

## Logical Grouping Strategies

### Group Together

- **Same feature**: All files for a new capability
- **Bug fix scope**: All files needed to fix one bug
- **Refactoring boundary**: Related structural changes
- **Documentation set**: Related doc updates
- **Test coverage**: Tests for one component

### Keep Separate

- **Different features**: Even if in same file
- **Unrelated fixes**: Multiple bugs = multiple commits
- **Different types**: Don't mix feat + fix + docs
- **Independent changes**: Changes that could be reviewed separately

### Examples

**Good Grouping**:

```
Commit 1: feat(cache): add Moka caching to person queries
  - src/domain/services/person_service.rs (cache implementation)
  - Cargo.toml (moka dependency)

Commit 2: test(cache): add person service cache tests
  - src/domain/services/person_service.rs (test module)

Commit 3: docs(cache): document caching strategy
  - CLAUDE.md (cache section)
  - README.md (architecture update)
```

**Bad Grouping**:

```
Commit 1: feat: add caching and fix auth bug and update docs
  - src/domain/services/person_service.rs
  - src/middleware/auth.rs
  - CLAUDE.md
  - README.md
```

## Edge Cases & Error Handling

**No Changes**:

- Check `git status` first
- If clean: "No uncommitted changes to commit"
- Exit gracefully

**Untracked Files**:

- Include in analysis
- Prompt if large binary files detected
- Respect .gitignore

**Merge Conflicts**:

- Detect via `git status`
- Do not attempt to commit
- Instruct user to resolve conflicts first

**Large Number of Changes**:

- If >20 files modified, warn about complexity
- Ask user to confirm grouping strategy
- Suggest reviewing groups before committing

**Staged Changes Present**:

- If staged changes exist, commit them as a single group
- Do NOT analyze or regroup - user has already chosen the grouping
- Generate appropriate commit message for all staged changes together
- After committing staged changes, check for remaining unstaged changes
- If unstaged changes remain, ask user if they want to commit those too

**Empty Commit Messages**:

- If message generation fails, prompt user
- Show proposed grouping and ask for message
- Don't commit without valid message

## Validation

Before each commit:

- ✅ Message follows conventional commit format
- ✅ Subject line ≤50 characters
- ✅ Subject uses imperative mood
- ✅ Subject capitalized, no period
- ✅ Body (if present) explains WHY, not WHAT
- ✅ Body (if present) is ≤72 chars per line
- ✅ All files in group are related
- ✅ Commit is atomic (could be reverted independently)

After all commits:

- ✅ All changes are committed
- ✅ Working directory is clean
- ✅ Each commit has meaningful message
- ✅ Commits are in logical order

## Context

Additional user context: $ARGUMENTS

## Example Output

```
Analyzing uncommitted changes...

Found 8 modified files grouped into 3 logical commits:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Commit 1/3: feat(cache): add person query caching

Files:
  - src/domain/services/person_service.rs
  - Cargo.toml

Changes: Added Moka cache with 24h TTL for person queries

✅ Committed: a1b2c3d

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Commit 2/3: test(cache): add cache hit/miss tests

Files:
  - src/domain/services/person_service.rs

Changes: Added unit tests for cache behavior

✅ Committed: d4e5f6g

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Commit 3/3: docs(cache): document caching strategy

Files:
  - CLAUDE.md
  - README.md
  - leads-queries/README.md

Changes: Updated documentation with caching details

✅ Committed: h7i8j9k

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Successfully created 3 atomic commits
📝 All changes committed, working directory clean

Next steps:
  - Review commits: git log -3 --oneline
  - Push to remote: git push origin <branch>
  - Create PR if ready for review
```
