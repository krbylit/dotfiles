---
description: Save current conversation context and project state to a markdown file for loading in future conversations
allowed-tools: Bash, Read, Write
argument-hint: [output-file] [optional: --scope brief|detailed|comprehensive]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command creates a comprehensive context dump file that captures the current conversation, project goals, codebase understanding, and progress. The dump is designed to be read by a fresh Claude CLI instance, enabling seamless continuation without loss of context.

### Core Objective

**Success Criteria**: A new Claude CLI conversation can read this file and immediately understand:

1. What this codebase is and what it does
2. How it relates to other services/repos
3. What we're currently working on and why
4. Where we are in the process
5. What the next steps should be

### Execution Steps

1. **Parse Arguments**:
   - Extract output file path (default: `context_dump_YYYY-MM-DD_HHMM.md`)
   - Extract scope level if provided:
     - `brief`: Essential context only (~500-1000 words)
     - `detailed`: Comprehensive context (default, ~1500-2500 words)
     - `comprehensive`: Everything including technical details (~3000+ words)
   - If no output path provided, use default in current directory

2. **Gather Current State**:
   - Get current git branch: `git rev-parse --abbrev-ref HEAD`
   - Get current git status: `git status --short`
   - Get recent commits: `git log --oneline -10`
   - Check for uncommitted changes
   - Identify current working files (recently modified)

3. **Analyze Project Structure**:
   - Read project CLAUDE.md if exists
   - Read README.md if exists
   - Read Cargo.toml/package.json/etc for project metadata
   - Identify key directories and their purposes
   - Map out important files currently in context

4. **Capture Conversation Context**:

   For each section, extract information that would be critical for a new conversation:

   **a. Project Overview** (ALWAYS INCLUDE):
   - What is this project/service?
   - What problem does it solve?
   - What architecture/pattern does it follow?
   - Key technologies and why they're used
   - Project maturity (new/active development/maintenance)

   **b. Related Services & External Context** (CRITICAL):
   - What other services/repos does this interact with?
   - How do they relate? (data flow, dependencies, etc.)
   - Any important context about external systems
   - Integration points and contracts
   - THIS IS CRUCIAL: Don't make user re-explain external systems!

   **c. Current Work & Goals** (ALWAYS INCLUDE):
   - What feature/task/bug are we working on?
   - Why are we doing this work? (business/technical reason)
   - What approach/strategy did we decide on?
   - What alternatives did we consider and reject?
   - Current phase: research/planning/implementation/testing/review?

   **d. Progress & Status** (ALWAYS INCLUDE):
   - What have we completed so far?
   - What's currently working?
   - What's not working yet?
   - Any blockers or issues?
   - Any temporary hacks or TODOs to remember?

   **e. Technical Decisions** (DETAILED/COMPREHENSIVE):
   - Architecture decisions made in this conversation
   - Patterns we're following
   - Why we chose specific approaches
   - Tradeoffs we accepted
   - Constraints we're working within

   **f. Code Locations** (DETAILED/COMPREHENSIVE):
   - Important files and what they contain
   - Where to find key functionality
   - File organization and structure
   - Any non-obvious locations

   **g. Test Strategy** (if applicable):
   - Testing approach
   - What's tested, what's not
   - Test locations
   - Coverage goals

   **h. Next Steps** (ALWAYS INCLUDE):
   - What should we do next?
   - Ordered priority list
   - Dependencies between steps
   - Expected outcomes

   **i. Open Questions** (if any):
   - What's still unclear?
   - Decisions that need to be made
   - Information we're waiting on

5. **Structure the Dump File**:

   Use this template structure:

   ```markdown
   # Claude Context Dump - [Project Name]

   **Generated**: YYYY-MM-DD HH:MM
   **Branch**: [current-branch]
   **Scope**: [brief|detailed|comprehensive]
   **Purpose**: [one-line summary of current work]

   ---

   ## Quick Start for New Conversation

   > **TL;DR**: [2-3 sentence summary of project and current goal]

   **To continue this work**:

   1. Read this document completely
   2. Confirm understanding by summarizing the project and current state
   3. Ask clarifying questions before proceeding
   4. Continue with [next step from Next Steps section]

   ---

   ## Project Overview

   ### What This Is

   [Comprehensive description of the project]

   ### Purpose & Problem

   [What problem this solves, who it's for]

   ### Architecture & Patterns

   [Key architectural decisions, patterns, technologies]

   ### Project Status

   [Maturity level, current phase]

   ---

   ## External Context & Related Services

   > **IMPORTANT**: This section captures context about external systems
   > so you don't have to re-explain them in new conversations.

   ### Related Services

   [For each related service/repo]:

   #### [Service Name]

   - **Purpose**: What it does
   - **Relationship**: How it relates to this project
   - **Integration Points**: How they communicate
   - **Important Context**: Any critical details

   ### External Systems

   [Any third-party services, databases, etc.]

   ---

   ## Current Work

   ### Goal

   [What we're trying to accomplish]

   ### Why

   [Business or technical motivation]

   ### Approach

   [Strategy and methodology we chose]

   ### Alternatives Considered

   [What we decided NOT to do and why]

   ---

   ## Progress & Status

   ### Completed ✅

   - [List of completed items]

   ### In Progress 🚧

   - [Current tasks]

   ### Not Started ⏸️

   - [Planned but not yet begun]

   ### Blockers 🚫

   - [Issues preventing progress]

   ### Temporary Notes 📝

   - [TODOs, hacks, things to remember]

   ---

   ## Technical Details

   [DETAILED/COMPREHENSIVE only]

   ### Key Decisions

   [Important architecture/design choices]

   ### Code Organization

   [File structure and locations]

   #### Critical Files

   | File Path | Purpose | Notes |
   | --------- | ------- | ----- |
   | ...       | ...     | ...   |

   ### Patterns & Conventions

   [Coding patterns we're following]

   ---

   ## Testing

   [If applicable]

   ### Strategy

   [Testing approach]

   ### Coverage

   [What's tested, what's not]

   ### Test Locations

   [Where tests are]

   ---

   ## Next Steps

   ### Immediate (Do First)

   1. [Ordered list of next steps]

   ### Subsequent (Do After)

   1. [Following steps]

   ### Dependencies

   [What depends on what]

   ---

   ## Open Questions

   [If any]

   - [ ] [Question or decision needed]

   ---

   ## Git State

   **Branch**: `[branch-name]`

   **Status**:
   ```

   [git status output]

   ```

   **Recent Commits**:
   ```

   [git log output]

   ```

   **Modified Files**:
   [List of uncommitted changes]

   ---

   ## Conversation Summary

   [High-level summary of this conversation's key points]

   ### Key Insights
   - [Important realizations or discoveries]

   ### Decisions Made
   - [Choices we made and why]

   ### Context Captured
   - [Important context that shouldn't be lost]

   ---

   ## Loading This Context

   When starting a new conversation with this dump:

   1. **Run**: `/context-load [this-file]`
   2. **Or manually**:
      - Read entire document
      - Summarize understanding
      - Ask clarifying questions
      - Proceed with Next Steps

   ---

   ## Metadata

   **Scope Level**: [brief|detailed|comprehensive]
   **Word Count**: [approximate]
   **Sections**: [number of main sections]
   **Related Files**: [key files mentioned]
   **Last Updated**: [timestamp]
   ```

6. **Generate Each Section**:

   For BRIEF scope:
   - Project Overview (condensed)
   - External Context (if exists)
   - Current Work
   - Progress & Status
   - Next Steps

   For DETAILED scope (default):
   - All brief sections
   - Technical Details (key decisions)
   - Testing (if applicable)
   - Open Questions
   - Git State

   For COMPREHENSIVE scope:
   - All detailed sections
   - Full Technical Details
   - Code Organization with table
   - Patterns & Conventions
   - Conversation Summary

7. **Write the File**:
   - Create the markdown file at specified path
   - Use proper markdown formatting
   - Include tables where appropriate
   - Add horizontal rules for section separation
   - Ensure consistent heading hierarchy

8. **Validate Output**:
   - ✅ File created successfully
   - ✅ All required sections present for scope level
   - ✅ External services documented (if any mentioned)
   - ✅ Next steps clearly defined
   - ✅ Git state captured
   - ✅ Markdown syntax valid
   - ✅ Tables formatted correctly
   - ✅ File readable and well-structured

9. **Report Results**:

   ```
   ✅ Context dump created: [file-path]

   📊 Summary:
   - Scope: [level]
   - Sections: [count]
   - Word count: ~[number]
   - External services documented: [count]

   📝 Contents:
   - Project overview
   - Current work: [one-line summary]
   - Progress: [X] completed, [Y] in progress
   - Next step: [first next step]

   💡 To load in a new conversation:
   Run: /context-load [file-path]

   Or read manually and summarize your understanding before proceeding.
   ```

## Critical Success Factors

**The dump MUST enable a new conversation to**:

1. **Understand the Project**:
   - Purpose and architecture
   - Key technologies and why
   - Relationship to other services
   - Current maturity and status

2. **Understand External Context**:
   - Related services and how they work
   - Integration points
   - External dependencies
   - NO need for user to re-explain

3. **Understand Current Work**:
   - What we're building/fixing
   - Why it's important
   - Approach we chose
   - Where we are in the process

4. **Continue Seamlessly**:
   - Pick up exactly where we left off
   - Know what to do next
   - Have all necessary context
   - Ask informed clarifying questions

**If ANY of these fail, the dump is insufficient.**

## Scope Level Guidelines

### BRIEF (~500-1000 words)

**Use when**: Quick checkpoint, simple task, minimal external context

**Include**:

- Essential project info
- Current goal
- Progress status
- Next steps

**Omit**:

- Detailed technical decisions
- Code organization
- Full conversation history

### DETAILED (~1500-2500 words) [DEFAULT]

**Use when**: Standard context preservation, moderate complexity

**Include**:

- All BRIEF content
- Key technical decisions
- External service relationships
- Git state
- Testing approach

**Omit**:

- Exhaustive technical details
- Full code organization table

### COMPREHENSIVE (~3000+ words)

**Use when**: Complex projects, many external dependencies, critical decisions

**Include**:

- All DETAILED content
- Full technical details
- Complete code organization
- Patterns and conventions
- Conversation summary
- All insights and decisions

## Examples

### Example 1: Brief Scope for Simple Bug Fix

```markdown
# Claude Context Dump - leads-queries

**Generated**: 2025-11-17 14:30
**Branch**: fix-null-agency-id
**Scope**: brief
**Purpose**: Fix null agency_id handling in JWT middleware

## Quick Start for New Conversation

> **TL;DR**: Rust CQRS query service. Fixing bug where null agency_id in JWT causes panic.

**To continue**: Read this doc, confirm understanding, continue with testing the fix.

## Project Overview

leads-queries is a Rust-based query service for CQRS/ES pattern. Reads projections from KurrentDB, serves REST endpoints, enforces multi-tenancy via JWT.

## Current Work

**Goal**: Handle null/missing agency_id in JWT gracefully (return 401, not panic)
**Why**: Production crashes when malformed JWTs received
**Approach**: Add validation in auth middleware before extracting claims

## Progress & Status

✅ Completed: Identified panic location in middleware/auth.rs:45
🚧 In Progress: Adding validation logic
⏸️ Not Started: Writing tests, deploying fix

## Next Steps

1. Add null check for agency_id claim
2. Return 401 Unauthorized if null/missing
3. Write unit test for null agency_id
4. Write unit test for missing agency_id
5. Test manually with malformed JWT
6. Commit fix
7. Deploy to staging
```

### Example 2: Detailed Scope for Feature Work

```markdown
# Claude Context Dump - leads-queries

**Generated**: 2025-11-17 14:30
**Branch**: add-person-caching
**Scope**: detailed
**Purpose**: Add caching layer to person query service

## Quick Start for New Conversation

> **TL;DR**: CQRS query service for leads system. Adding Moka cache to person queries to reduce EventStore load and improve response times.

**To continue**: Read this doc, confirm understanding of caching strategy and multi-tenancy requirements, continue with cache invalidation implementation.

## Project Overview

### What This Is

`leads-queries` is the query side of a CQRS/ES microservice for lead management. Written in Rust using Axum. Reads projections from KurrentDB (EventStoreDB fork), serves REST API.

### Purpose & Problem

Provides fast read access to PersonSummary and Operation projections for the leads system frontend. Separates read model from command model for scalability.

### Architecture & Patterns

- Service layer architecture
- JWT-based multi-tenancy
- Event sourcing projections
- REST API with OpenAPI docs
- Domain-driven design

### Project Status

Active development. Core query features working. Adding performance optimizations (caching).

## External Context & Related Services

### leads-commands

- **Purpose**: Command side of CQRS, handles writes
- **Relationship**: This service reads from events that leads-commands writes
- **Integration**: Both use KurrentDB, no direct service calls
- **Important Context**: Commands append events to person-{id} streams, we read and fold those events into projections

### KurrentDB

- **Purpose**: Event store (EventStoreDB fork)
- **Relationship**: Primary data source for projections
- **Integration**: EventStore client library, reads event streams
- **Important Context**: Multi-tenancy via event metadata (agency_id field)

## Current Work

### Goal

Add in-memory caching to PersonQueryService to reduce KurrentDB load and improve response times for frequently-accessed person queries.

### Why

Person queries are high-frequency and projections change infrequently. Analytics show 80% of queries are for same 20% of persons. EventStore reads are slow (~200ms) vs cache (<1ms).

### Approach

- Use Moka cache (Rust equivalent of Caffeine)
- 24-hour TTL
- Cache key: `person:{agency_id}:{person_id}` (prevent cross-tenant)
- Cache-aside pattern: check cache, read from EventStore on miss, populate cache
- Manual invalidation (future: event-based invalidation)

### Alternatives Considered

- Redis: Rejected - adds operational complexity, network latency
- Longer TTL: Rejected - data freshness concerns
- No caching: Rejected - performance critical

## Progress & Status

### Completed ✅

- Added Moka dependency to Cargo.toml
- Created cache in PersonQueryService
- Implemented cache-aside pattern in get_person_summary()
- Return cache_hit flag in response for monitoring

### In Progress 🚧

- Implementing manual cache invalidation API
- Adding cache hit/miss metrics

### Not Started ⏸️

- Integration tests for caching
- Event-based invalidation (future enhancement)
- Cache warming on startup

### Temporary Notes 📝

- TODO: Consider cache size limits (currently unbounded)
- TODO: Monitor memory usage in production
- HACK: Cache key format may need adjustment if we add more query params

## Technical Details

### Key Decisions

**Why Moka over other options**:

- In-memory = no network latency
- Rust-native, well-maintained
- TTL support built-in
- Thread-safe, lock-free

**Why 24h TTL**:

- Balances freshness vs hit rate
- Person data rarely changes
- Can manually invalidate if needed

**Why cache key includes agency_id**:

- Critical for multi-tenancy
- Prevents cross-agency cache pollution
- Security: even bugs won't leak data

### Code Organization

#### Critical Files

| File Path                             | Purpose                       | Notes                                 |
| ------------------------------------- | ----------------------------- | ------------------------------------- |
| src/domain/services/person_service.rs | PersonQueryService with cache | Cache implementation here             |
| src/api/handlers/persons.rs           | HTTP handlers                 | Calls service, returns cache_hit flag |
| Cargo.toml                            | Dependencies                  | Moka = "0.12"                         |

## Next Steps

### Immediate (Do First)

1. Implement cache invalidation endpoint: POST /v1/persons/{id}/cache/invalidate
2. Add unit tests for cache hit/miss scenarios
3. Add unit tests for cache invalidation

### Subsequent (Do After)

4. Add integration tests
5. Add metrics for cache hit rate
6. Deploy to staging and monitor
7. Analyze cache performance in production
8. Consider cache size limits based on metrics

### Dependencies

- Tests depend on cache invalidation being implemented
- Metrics can be added in parallel
- Deployment depends on all tests passing

## Git State

**Branch**: `add-person-caching`

**Status**:
```

M Cargo.toml
M src/domain/services/person_service.rs
M src/api/handlers/persons.rs

```

**Recent Commits**:
```

a1b2c3d feat(cache): add Moka caching to person queries
d4e5f6g refactor(service): extract cache logic to methods

```

## Loading This Context

Run: `/context-load context_dump_2025-11-17_1430.md`
```

## Edge Cases & Error Handling

**No Conversation Context**:

- If this is the first message in a conversation, explain that context is limited
- Ask user to describe what should be captured
- Prompt for project overview, current work, external services

**Cannot Determine Current Work**:

- Look at git branch name for hints
- Check recent commits for patterns
- Ask user to clarify current goal

**External Services Not Discussed**:

- Only include if they've been mentioned in conversation
- Don't invent relationships
- If user mentioned external systems but details are vague, note "mentioned but needs clarification"

**Long Conversation**:

- For very long conversations (>50 messages), focus on:
  - Most recent decisions
  - Key insights throughout
  - Current state (not full history)

**Output File Exists**:

- Append timestamp to filename to avoid overwrite
- Inform user that previous dump exists
- Suggest comparing or archiving old dump

## Validation Checklist

Before finalizing the dump, verify:

- [ ] Project purpose clearly explained
- [ ] External services documented (if any)
- [ ] Current work goal stated
- [ ] Progress status captured
- [ ] Next steps defined and ordered
- [ ] Git state included
- [ ] File paths mentioned are accurate
- [ ] Markdown formatting valid
- [ ] Tables formatted correctly
- [ ] Scope level matches request
- [ ] No sensitive data included
- [ ] Context sufficient for new conversation to continue

## Context

User-provided context: $ARGUMENTS

## Notes

- This dump should be **self-contained**: a new Claude instance with zero context should be able to read this and understand everything
- **External services are critical**: Don't make user re-explain how related repos/services work
- **Be specific**: Vague summaries don't help. Include file paths, specific decisions, concrete next steps
- **Focus on WHY**: Not just what we're doing, but why we're doing it and why this approach
- **Git state matters**: Knowing the branch, uncommitted changes, recent commits provides valuable context
- **Tables for clarity**: Use tables for file organization, progress tracking, etc.
- **Next steps must be actionable**: Not "finish the feature" but "implement cache invalidation endpoint at POST /v1/persons/{id}/cache/invalidate"
