---
description: Load a context dump file to restore project understanding and conversation state from a previous session
allowed-tools: Read
argument-hint: <dump-file-path>
model: sonnet
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command loads a context dump file created by `/context-dump` and primes the current conversation with all necessary context to seamlessly continue work from a previous session.

### Core Objective

**Success Criteria**: After loading this context, you should:

1. Fully understand the project and its purpose
2. Know about all related services/repos and how they interact
3. Understand what we were working on and why
4. Know exactly where we left off
5. Be ready to continue with the next steps
6. Ask informed clarifying questions if needed

### Execution Steps

1. **Parse Arguments**:
   - Extract dump file path from $ARGUMENTS or $1
   - If no file specified: ERROR "Please provide dump file path: /context-load <file-path>"
   - Validate file exists
   - If file doesn't exist: List available dumps in current directory

2. **Read the Context Dump**:
   - Read entire dump file
   - Parse markdown structure
   - Extract all sections
   - Identify scope level (brief/detailed/comprehensive)

3. **Process Each Section Systematically**:

   **a. Project Overview**:
   - Understand project purpose and problem it solves
   - Note architecture and patterns
   - Identify key technologies
   - Understand project maturity/status
   - **Internalize**: You now know what this project is

   **b. External Context & Related Services**:
   - **CRITICAL SECTION**: Study each related service
   - Understand relationships and integration points
   - Note important context about each external system
   - **Internalize**: You now know the ecosystem without needing user to re-explain

   **c. Current Work**:
   - Understand the goal and why it matters
   - Note the approach chosen
   - Review alternatives that were rejected
   - **Internalize**: You know what we're trying to accomplish and why

   **d. Progress & Status**:
   - Note what's completed
   - Understand what's in progress
   - Identify what's not started
   - Be aware of blockers
   - Note temporary hacks/TODOs
   - **Internalize**: You know exactly where we are

   **e. Technical Details** (if present):
   - Study key decisions and their reasoning
   - Review code organization and critical files
   - Understand patterns and conventions being followed
   - **Internalize**: You know the technical landscape

   **f. Testing** (if present):
   - Understand testing strategy
   - Note what's tested vs not tested
   - Know where tests are located
   - **Internalize**: You know the testing approach

   **g. Next Steps**:
   - Study the ordered list of next steps
   - Understand dependencies between steps
   - Note expected outcomes
   - **Internalize**: You know what to do next

   **h. Open Questions** (if present):
   - Note unresolved questions
   - Understand pending decisions
   - Identify needed information
   - **Internalize**: You know what's still unclear

   **i. Git State**:
   - Note current branch
   - Review recent commits
   - Understand working directory state
   - **Internalize**: You know the repository state

4. **Synthesize Understanding**:

   Create a mental model that integrates:
   - Project architecture
   - Related services and their roles
   - Current objectives
   - Work completed so far
   - Remaining work
   - Known issues and constraints

5. **Confirm Understanding**:

   Provide a structured summary to demonstrate you've internalized the context:

   ```markdown
   ✅ Context loaded from [dump-file-path]

   ## My Understanding

   ### Project

   [2-3 sentence summary of what this project is and does]

   ### External Services

   [For each related service, one sentence about its role and relationship]

   ### Current Goal

   [One sentence about what we're working on and why]

   ### Progress

   - ✅ Completed: [key items]
   - 🚧 In Progress: [current work]
   - ⏸️ Next: [immediate next step]

   ### Technical Context

   [Key decisions or constraints I should keep in mind]

   ### Ready to Continue With

   [The next step from the Next Steps section]

   ## Clarifying Questions

   [If anything is unclear or ambiguous, ask 2-3 specific questions]

   OR

   [If everything is clear:]
   No clarifying questions - ready to proceed!

   ---

   **Shall I proceed with [next step]?**
   ```

6. **Wait for User Confirmation**:
   - Do NOT automatically start working
   - Let user confirm your understanding is correct
   - Let user provide additional context if needed
   - Let user approve proceeding with next steps
   - User may want to adjust direction

7. **Ready State**:
   - You are now primed with full context
   - You understand the project, ecosystem, and current work
   - You can make informed decisions
   - You can ask intelligent questions
   - You can continue seamlessly from where previous conversation left off

## Understanding Verification Template

Use this template to structure your understanding summary:

```markdown
✅ **Context Successfully Loaded**

📁 **Source**: [dump-file-name]
📅 **Dump Created**: [timestamp from dump]
🌿 **Branch**: [branch-name]
📊 **Scope**: [brief/detailed/comprehensive]

---

## 🎯 Project Understanding

**What it is**: [Project name and purpose in one sentence]

**Problem it solves**: [The core problem/need]

**Architecture**: [Key architectural pattern - e.g., "CQRS/ES microservice with REST API"]

**Tech Stack**: [Main technologies - e.g., "Rust, Axum, KurrentDB, Moka cache"]

**Status**: [Maturity level - e.g., "Active development, core features working"]

---

## 🔗 External Services & Integration

[For each service mentioned in dump:]

### [Service Name]

- **Role**: [What it does]
- **Relationship**: [How it connects to this project]
- **Key Detail**: [Most important thing to remember]

---

## 🎯 Current Work

**Goal**: [What we're trying to accomplish]

**Why**: [The motivation - business or technical reason]

**Approach**: [Strategy being used - in one sentence]

**Status**: [Current phase - e.g., "Implementation in progress, testing next"]

---

## 📋 Progress Status

### ✅ Completed

- [Key completed items]

### 🚧 In Progress

- [Current work items]

### ⏸️ Not Started

- [Planned items]

### 🚫 Blockers (if any)

- [Blocking issues]

---

## 🔧 Key Technical Context

- [Important decision or constraint #1]
- [Important decision or constraint #2]
- [Important pattern or convention to follow]

---

## 📂 Critical Files I Should Know About

[If detailed/comprehensive dump includes file list:]

- `[file-path]` - [purpose]
- `[file-path]` - [purpose]

---

## ▶️ Next Steps

**Immediate next action**: [First item from Next Steps section]

**Following steps**:

1. [Step 2]
2. [Step 3]

**Dependencies**: [Any noted dependencies between steps]

---

## ❓ Clarifying Questions

[Ask 2-3 specific questions if anything is unclear, such as:]

1. [Specific question about unclear aspect]
2. [Question about ambiguous requirement]
3. [Question about technical detail that needs clarification]

**OR** (if everything is clear):

✅ No clarifying questions - context is clear and I'm ready to proceed!

---

## 🚀 Ready to Proceed?

I understand the context and am ready to continue with: **[next step]**

Shall I proceed? Or would you like to:

- Provide additional context
- Adjust the direction
- Ask me questions to verify my understanding
- Start with a different task
```

## Prompting Strategy

When you read the context dump, adopt this mental framework:

### Role Assignment

"I am now a developer who has been working on this project and taking a break. I'm coming back to continue the work. This context dump is my notes from the previous session."

### Deep Reading

- Don't skim - internalize every detail
- Pay special attention to WHY things were done
- Note all external service relationships
- Understand the reasoning behind decisions

### Integration

- Connect the dots between different sections
- Understand how project overview relates to current work
- See how technical decisions support the goals
- Recognize how external services fit into the architecture

### Question Generation

- Identify anything ambiguous or unclear
- Note missing information that would help
- Recognize areas where assumptions might be wrong
- Ask specific, targeted questions (not general ones)

## Edge Cases & Error Handling

**File Not Found**:

```
❌ Context dump file not found: [path]

Available context dumps in current directory:
- context_dump_2025-11-17_1430.md (detailed, 2.3k words)
- context_dump_2025-11-16_0920.md (brief, 0.8k words)

Please specify which file to load:
/context-load [file-path]
```

**Invalid/Corrupted File**:

- If file is not a valid markdown context dump
- ERROR: "This doesn't appear to be a valid context dump file"
- Ask user if they want to try reading it anyway
- Attempt to extract what information is available

**Incomplete Context Dump**:

- If dump is missing critical sections (Project Overview, Current Work, Next Steps)
- WARN: "This context dump appears incomplete - missing [sections]"
- Load what's available
- Note missing sections in understanding summary
- Ask user to fill in gaps

**Conflicting Information**:

- If dump contains contradictory statements
- Note the conflicts in your understanding summary
- Ask user to clarify which is correct

**Outdated Dump**:

- If dump is >7 days old (check timestamp)
- WARN: "This context dump is from [date] - [X days old]"
- Ask if user wants to proceed or create fresh dump
- Note that codebase may have changed

**Multiple Dumps Available**:

- If user didn't specify which dump and multiple exist
- List available dumps with metadata:
  - Filename
  - Date created
  - Scope level
  - Brief summary line
- Ask user to select one

## Validation Checklist

After loading context, verify you can answer these questions:

- [ ] What is this project and what does it do?
- [ ] What architecture/pattern does it follow?
- [ ] What external services does it interact with and how?
- [ ] What are we currently working on?
- [ ] Why are we doing this work?
- [ ] What approach/strategy did we choose?
- [ ] What have we completed so far?
- [ ] What's the next step?
- [ ] What are the key technical constraints or decisions?
- [ ] Where are the critical files/code?

**If you cannot answer ANY of these, the context load has failed.**

Ask user to provide missing information before proceeding.

## Examples

### Example 1: Successful Load with Clear Context

```markdown
✅ **Context Successfully Loaded**

📁 **Source**: context_dump_2025-11-17_1430.md
📅 **Dump Created**: 2025-11-17 14:30
🌿 **Branch**: add-person-caching
📊 **Scope**: detailed

---

## 🎯 Project Understanding

**What it is**: leads-queries - CQRS query service for lead management system

**Problem it solves**: Provides fast read access to PersonSummary and Operation projections, separated from command model for scalability

**Architecture**: Service layer with CQRS/ES pattern, reads from EventStore projections, serves REST API

**Tech Stack**: Rust, Axum, KurrentDB (EventStore fork), Moka cache, JWT auth

**Status**: Active development, core features working, adding performance optimizations

---

## 🔗 External Services & Integration

### leads-commands

- **Role**: Command side of CQRS, handles all write operations
- **Relationship**: Writes events that this service reads and projects
- **Key Detail**: No direct communication - both use KurrentDB as integration point

### KurrentDB

- **Role**: Event store (EventStoreDB fork)
- **Relationship**: Primary data source - we read event streams and fold into projections
- **Key Detail**: Multi-tenancy enforced via agency_id in event metadata

---

## 🎯 Current Work

**Goal**: Add in-memory caching to PersonQueryService using Moka

**Why**: Person queries are high-frequency, projections rarely change, EventStore reads are slow (~200ms), 80/20 access pattern observed

**Approach**: Cache-aside pattern with 24h TTL, cache key includes agency_id for multi-tenancy, manual invalidation API

**Status**: Core caching implemented, working on invalidation endpoint and tests

---

## 📋 Progress Status

### ✅ Completed

- Added Moka dependency
- Implemented cache in PersonQueryService
- Cache-aside pattern in get_person_summary()
- Return cache_hit flag for monitoring

### 🚧 In Progress

- Implementing cache invalidation endpoint
- Adding cache hit/miss metrics

### ⏸️ Not Started

- Integration tests for caching
- Event-based invalidation (future)
- Cache warming on startup

---

## 🔧 Key Technical Context

- Cache key MUST include agency_id to prevent cross-tenant data leakage
- 24h TTL chosen to balance freshness vs hit rate
- Moka chosen over Redis to avoid network latency and operational complexity
- Service layer pattern - all business logic in domain/services/
- Multi-tenancy enforced at multiple layers (JWT, projections, cache)

---

## 📂 Critical Files I Should Know About

- `src/domain/services/person_service.rs` - PersonQueryService with cache implementation
- `src/api/handlers/persons.rs` - HTTP handlers that call service
- `Cargo.toml` - Dependencies including moka = "0.12"

---

## ▶️ Next Steps

**Immediate next action**: Implement cache invalidation endpoint at POST /v1/persons/{id}/cache/invalidate

**Following steps**:

1. Add unit tests for cache hit/miss scenarios
2. Add unit tests for cache invalidation
3. Add integration tests
4. Add metrics for cache hit rate
5. Deploy to staging and monitor

**Dependencies**: Tests depend on invalidation being implemented first

---

## ❓ Clarifying Questions

✅ No clarifying questions - context is clear and I'm ready to proceed!

---

## 🚀 Ready to Proceed?

I understand the context and am ready to continue with: **Implementing cache invalidation endpoint at POST /v1/persons/{id}/cache/invalidate**

Shall I proceed?
```

### Example 2: Load with Questions

```markdown
✅ **Context Successfully Loaded**

📁 **Source**: context_dump_2025-11-17_0920.md
📅 **Dump Created**: 2025-11-17 09:20
🌿 **Branch**: fix-null-agency-id
📊 **Scope**: brief

---

## 🎯 Project Understanding

**What it is**: leads-queries - CQRS query service

**Problem it solves**: Fast read access to projections for leads system

**Architecture**: CQRS/ES with REST API

**Tech Stack**: Rust, Axum, KurrentDB

**Status**: Active development

---

## 🎯 Current Work

**Goal**: Fix null agency_id handling in JWT middleware

**Why**: Production crashes when malformed JWTs received

**Approach**: Add validation in auth middleware before extracting claims

**Status**: Identified panic location, adding validation logic

---

## 📋 Progress Status

### ✅ Completed

- Identified panic location (middleware/auth.rs:45)

### 🚧 In Progress

- Adding validation logic

### ⏸️ Not Started

- Writing tests
- Deploying fix

---

## ▶️ Next Steps

**Immediate next action**: Add null check for agency_id claim

**Following steps**:

1. Return 401 if null/missing
2. Write unit test for null agency_id
3. Write unit test for missing agency_id
4. Test manually with malformed JWT
5. Commit and deploy

---

## ❓ Clarifying Questions

I have a few questions to ensure I implement this correctly:

1. **JWT Structure**: What is the expected structure of the JWT claims? Is agency_id a top-level claim or nested?

2. **Error Response**: Should the 401 response include details about the validation failure, or just generic "Unauthorized"?

3. **Logging**: Should we log these validation failures for security monitoring?

---

## 🚀 Ready to Proceed?

Once you clarify the above questions, I'm ready to implement the null check validation.

What would you like me to do?
```

## Context

User-provided arguments: $ARGUMENTS

## Notes

- **Internalize, don't just read**: You need to truly understand the context, not just acknowledge it
- **External services are critical**: Pay special attention to this section - it saves user from re-explaining entire systems
- **Ask good questions**: If anything is unclear, ask specific, targeted questions (not "tell me more about X")
- **Demonstrate understanding**: Your summary should prove you "get it" - be specific, use correct terminology, reference key details
- **Don't auto-proceed**: Always wait for user confirmation before starting work
- **Be ready for adjustments**: User may want to change direction after you load context - be flexible
- **Scope awareness**: Brief dumps have less detail - you may need to ask more questions
- **Git state matters**: Knowing the branch and recent commits helps you understand where things are
