---
description: Explain code with deep contextual understanding of architecture, patterns, and design decisions
allowed-tools: Read, Grep, Glob, Task
argument-hint: "[file-path or code-reference] [--depth=quick|standard|deep] [--audience=junior|mid|senior|domain-expert]"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command provides intelligent, context-aware code explanations that go beyond surface-level descriptions. It understands the broader codebase architecture, design patterns, and project-specific conventions to deliver explanations tailored to the audience.

### Execution Steps

1. **Parse Arguments**:

   **Supported formats**:
   - File path: `/explain src/domain/services/person_service.rs`
   - Function reference: `/explain PersonQueryService::get_person_summary`
   - Code pattern: `/explain "JWT validation middleware"`
   - Current file: `/explain` (explains file currently being viewed/edited)

   **Flags**:
   - `--depth=quick` (2-3 paragraphs, default)
   - `--depth=standard` (comprehensive, ~5-8 paragraphs)
   - `--depth=deep` (exhaustive with architecture context, ~10+ paragraphs)
   - `--audience=junior` (assumes basic language knowledge)
   - `--audience=mid` (assumes familiarity with patterns, default)
   - `--audience=senior` (focuses on trade-offs, design decisions)
   - `--audience=domain-expert` (assumes deep domain knowledge, focuses on implementation details)

2. **Gather Context**:

   a. **Read target code**:
   - If file path: Read entire file
   - If function/struct reference: Use Grep to locate, read surrounding context
   - If pattern/description: Use Grep to find relevant code, may find multiple locations

   b. **Understand project context**:
   - Read CLAUDE.md for architecture patterns
   - Read README.md for project overview
   - Identify related files (imports, dependencies)
   - Note: This is where you build understanding of how this code fits into the larger system

   c. **Gather related code**:
   - Read imported modules/traits/structs
   - Read test files for the target code (shows intended behavior)
   - Read caller code (shows how it's used)
   - Read called code (shows dependencies)

3. **Analyze Code Structure**:

   **For each major component** (function, struct, module, etc.):

   a. **Surface-level analysis**:
   - What does it do? (one-sentence summary)
   - Inputs and outputs
   - Side effects

   b. **Pattern recognition**:
   - Design patterns used (Repository, Service Layer, Builder, etc.)
   - Project-specific patterns (from CLAUDE.md)
   - Language idioms (Rust: Arc/Mutex, TypeScript: Promises, etc.)

   c. **Architecture context**:
   - Which layer? (API, Domain, Infrastructure, etc.)
   - Responsibilities in the system
   - Integration points with other components

   d. **Design decisions**:
   - Why this approach? (from code structure, comments, tests)
   - What alternatives exist?
   - What trade-offs were made?

4. **Structure Explanation**:

   **All explanations should follow this structure**:

   a. **High-Level Summary** (1-2 sentences):
   - What is this code?
   - What problem does it solve?

   b. **Purpose & Context** (1-2 paragraphs):
   - Why does this exist in the codebase?
   - How does it fit into the larger architecture?
   - What would break if this didn't exist?

   c. **How It Works** (varies by depth):
   - **Quick**: Key mechanism in 2-3 sentences
   - **Standard**: Step-by-step flow with important details
   - **Deep**: Complete flow with edge cases, error handling, concurrency, etc.

   d. **Key Design Decisions** (if depth=standard or deep):
   - Patterns used and why
   - Trade-offs made
   - Alternatives considered (if evident)

   e. **Important Details** (varies by audience):
   - **Junior**: Language-specific concepts explained (traits, async, etc.)
   - **Mid**: Pattern applications, best practices followed
   - **Senior**: Performance implications, scalability considerations
   - **Domain-expert**: Business logic nuances, domain model alignment

   f. **Usage Examples** (if depth=standard or deep):
   - Show how callers use this code
   - Include common patterns
   - Highlight edge cases

   g. **Related Code** (always include):
   - Links to related functions/modules
   - Suggest what to explore next
   - Mention test files for deeper understanding

5. **Tailor to Audience**:

   **Junior audience**:
   - Define technical terms
   - Explain language-specific features
   - Use analogies and comparisons
   - Focus on "what" and "how"

   **Mid audience** (default):
   - Assume pattern familiarity
   - Focus on "why" and "how"
   - Highlight best practices
   - Note deviations from conventions

   **Senior audience**:
   - Focus on trade-offs and alternatives
   - Discuss performance and scalability
   - Architecture and design decisions
   - Skip basic explanations

   **Domain-expert audience**:
   - Assume deep business logic understanding
   - Focus on implementation details
   - Discuss edge cases and constraints
   - Note domain model alignment

6. **Format Output**:

   Use markdown with clear sections:

   ```markdown
   # Explanation: [Code Reference]

   **Quick Summary**: [1-2 sentence overview]

   ## Purpose & Context

   [Why this exists, how it fits into architecture]

   ## How It Works

   [Step-by-step or conceptual flow]

   ## Key Design Decisions

   [Patterns, trade-offs, alternatives]

   ## Important Details

   [Audience-specific insights]

   ## Usage Examples

   [How callers use this code]

   ## Related Code

   - [Module/function]: [Why relevant]
   - [Test file]: [What behaviors are tested]
   ```

7. **Validate Explanation**:

   **Quality checklist**:
   - [ ] Accurately describes what the code does
   - [ ] Explains WHY, not just WHAT
   - [ ] Provides architectural context
   - [ ] Tailored to specified audience level
   - [ ] Includes concrete examples
   - [ ] Links to related code
   - [ ] Uses clear, precise language
   - [ ] Free of jargon (unless audience=senior/expert)
   - [ ] Mentions test files if they exist

## Depth Guidelines

### Quick (--depth=quick)

**When to use**: Fast understanding, initial exploration, unfamiliar codebase

**Structure**:

- High-level summary (1-2 sentences)
- Purpose & context (1 paragraph)
- How it works (2-3 key sentences)
- Related code (2-3 links)

**Example**:

```markdown
# Explanation: PersonQueryService::get_person_summary

**Quick Summary**: Fetches a person's summary projection from the event store with 24-hour caching.

## Purpose & Context

This service implements the query side of CQRS for person data. It sits in the domain layer and coordinates between the cache and projection client to optimize read performance for frequently accessed person data.

## How It Works

First checks the Moka cache for a cached version. On cache miss, it calls the KurrentProjectionClient to fold events from the `person-{id}` stream into a PersonSummaryData projection, then caches the result with a 24-hour TTL.

## Related Code

- `KurrentProjectionClient::read_projection` - Event folding logic
- `tests/person_service.rs` - Cache behavior tests
- `api/handlers/persons.rs` - HTTP endpoint that calls this service
```

### Standard (default)

**When to use**: Understanding implementation, reviewing code, onboarding

**Structure**:

- High-level summary (1-2 sentences)
- Purpose & context (1-2 paragraphs)
- How it works (5-8 paragraphs with step-by-step flow)
- Key design decisions (2-3 paragraphs)
- Important details (2-3 paragraphs)
- Usage examples (1-2 code snippets with explanation)
- Related code (4-6 links with context)

**Length**: ~5-8 paragraphs total

### Deep (--depth=deep)

**When to use**: Architecture review, major refactoring, debugging complex issues

**Structure**:

- High-level summary (2-3 sentences)
- Purpose & context (2-3 paragraphs including history/evolution)
- How it works (10+ paragraphs covering all flows, edge cases, error handling)
- Key design decisions (4-6 paragraphs with alternatives)
- Important details (4-6 paragraphs with performance, concurrency, security)
- Usage examples (3-5 code snippets)
- Related code (8+ links with detailed context)
- Architecture diagrams (if applicable)

**Length**: ~10+ paragraphs total

## Audience Guidelines

### Junior (--audience=junior)

**Assumptions**:

- Familiar with language syntax
- Basic understanding of common data structures
- Limited pattern knowledge
- New to the codebase

**Explanation style**:

- Define technical terms inline
- Explain patterns when used
- Use analogies
- Show concrete examples
- Avoid assuming context

**Example snippet**:

> This function uses the `Arc<dyn ProjectionClient>` pattern. `Arc` is Rust's atomic reference counter, which allows multiple parts of the code to safely share ownership of the projection client. The `dyn` keyword means "dynamic dispatch" - we don't know the exact type at compile time, just that it implements the ProjectionClient trait.

### Mid (--audience=mid) - DEFAULT

**Assumptions**:

- Familiar with common patterns (Repository, Service Layer, etc.)
- Understands language-specific idioms
- Some codebase context
- Can read code but wants to understand "why"

**Explanation style**:

- Focus on patterns and their application
- Explain design decisions
- Highlight best practices
- Note deviations from conventions
- Provide context about how pieces fit together

**Example snippet**:

> The service uses dependency injection via `Arc<dyn ProjectionClient>`, following the project's service layer pattern. This abstraction enables the future migration from EventStore to MongoDB without changing calling code - the MongoProjectionClient will implement the same trait.

### Senior (--audience=senior)

**Assumptions**:

- Deep pattern knowledge
- Strong language expertise
- Interested in architecture and trade-offs
- Evaluating design quality

**Explanation style**:

- Focus on trade-offs and alternatives
- Discuss performance implications
- Analyze scalability and maintainability
- Question design decisions
- Connect to broader architecture

**Example snippet**:

> The 24-hour cache TTL is a trade-off between data freshness and read performance. Person projections are mostly immutable (name changes are rare), making aggressive caching viable. The alternative would be event-based invalidation on PersonUpdated events, but that adds complexity and a new failure mode. Current analytics show 95% of queries are within 1-hour windows, so the 24-hour TTL provides minimal staleness risk while maintaining high hit rates.

### Domain-Expert (--audience=domain-expert)

**Assumptions**:

- Expert in business domain
- Interested in how code maps to domain concepts
- Focused on correctness and edge cases
- Understands the "why" of business rules

**Explanation style**:

- Map code to domain concepts
- Explain business rule implementation
- Discuss domain model alignment
- Highlight edge cases and constraints
- Focus on correctness over architecture

**Example snippet**:

> The `agency_id` filtering in event metadata enforces multi-tenancy at the data layer, ensuring PersonSummary projections only include events from the querying agency's context. This prevents cross-agency leakage even if the JWT validation layer were compromised. The 404 response (not 403) for cross-agency queries is intentional - it prevents existence disclosure attacks where an attacker could probe for person IDs across agencies.

## Edge Cases & Error Handling

**Invalid/ambiguous code reference**:

- If Grep returns multiple matches, list them and ask user to clarify
- If no matches found, suggest similar references using fuzzy matching
- If file doesn't exist, check for recent moves/renames in git log

**Large files/modules**:

- For files >1000 lines, ask if user wants specific function/section
- Offer to explain by sections (imports, types, functions, tests)
- For modules, explain module purpose first, then offer to drill into components

**Generated code**:

- Detect generated code (e.g., `src/domain/queries/generated/`)
- Explain the generation process, not the generated code itself
- Link to source schemas or generation tool

**External dependencies**:

- For third-party libraries, explain what the library does and why it's used
- Focus on how the project uses the library, not library internals
- Link to official docs for deeper library understanding

**Missing context**:

- If CLAUDE.md or README missing, note lack of documented architecture
- Make best-effort inference from code structure
- Suggest creating architecture documentation

## Examples

### Example 1: Quick explanation of a handler

**Command**: `/explain src/api/handlers/persons.rs --depth=quick`

**Output**:

```markdown
# Explanation: src/api/handlers/persons.rs

**Quick Summary**: HTTP handler for the GET /v1/persons/{id} endpoint that fetches person summaries with JWT authentication.

## Purpose & Context

This is the API layer entry point for person queries. It extracts the person ID from the URL path, validates the JWT for multi-tenancy, calls the PersonQueryService, logs the query for audit compliance, and returns JSON or 404.

## How It Works

Axum extracts the person_id from the path and AuthContext from the JWT middleware. The handler calls PersonQueryService::get_person_summary(), which handles caching and projection reading. If found, the handler logs a QueryJournaled event via QueryAuditor (for compliance), then returns the PersonSummaryData as JSON.

## Related Code

- `domain/services/person_service.rs` - Business logic and caching
- `middleware/auth.rs` - JWT validation that populates AuthContext
- `domain/queries/audit.rs` - QueryAuditor for compliance logging
```

### Example 2: Standard explanation for mid-level audience

**Command**: `/explain PersonQueryService::get_person_summary`

**Output**:

````markdown
# Explanation: PersonQueryService::get_person_summary

**Quick Summary**: Retrieves a person's summary projection from EventStore with in-memory caching to optimize frequent reads.

## Purpose & Context

This service implements the query side of CQRS for person data. In the service layer architecture, it sits between the API handlers (which know about HTTP) and the infrastructure clients (which know about EventStore). Its job is to coordinate caching and projection reading while keeping business logic separate from infrastructure concerns.

Person summaries are frequently queried (often multiple times for the same person within minutes), but they change infrequently (person data is mostly immutable). This makes them ideal candidates for aggressive caching.

## How It Works

The service follows a cache-aside pattern:

1. **Cache check**: First, it constructs a cache key using the format `person:{agency_id}:{person_id}`. The agency_id is included to prevent cache poisoning across tenants.

2. **Cache hit**: If the Moka cache contains an entry and it hasn't expired (24-hour TTL), return the cached data immediately with `cache_hit: true`.

3. **Cache miss**: If not cached, call `projection_client.read_projection("person", person_id, agency_id)`. The projection client reads events from the `person-{id}` stream and folds them into a PersonSummaryData structure.

4. **Multi-tenancy filtering**: The projection client filters events by `agency_id` in the event metadata. This ensures cross-agency queries return None (later translated to 404) rather than leaking data.

5. **Caching**: If a projection is found, insert it into the Moka cache with 24-hour TTL before returning.

6. **Return**: Return `Option<(PersonSummaryData, bool)>` where the bool indicates cache hit.

## Key Design Decisions

**Moka for caching**: Moka was chosen over other Rust cache libraries (like lru) because it provides:

- High-performance concurrent access (lock-free reads)
- Automatic eviction with TTL and size limits
- Arc-based cloning (cheap to share across handlers)

**24-hour TTL**: This is a deliberate trade-off between freshness and performance. Person data changes infrequently (name changes, contact updates are rare events), so a long TTL is acceptable. Analytics show 95% of queries happen within 1-hour windows, so staleness is minimal.

**Cache key includes agency_id**: This prevents a subtle security issue where an attacker could pollute the cache with data from their agency, then query for a person_id from another agency, potentially causing the wrong data to be returned if the cache didn't include tenant context.

**Returning cache_hit flag**: The handler uses this to include cache status in QueryJournaled events for analytics. This helps track cache effectiveness and identify potential cache-warming opportunities.

## Important Details

**Error handling**: Projection client errors (connection failures, stream not found, deserialization errors) bubble up as `QueryError::Projection`. The handler translates these to appropriate HTTP status codes (500 for infrastructure errors, 404 for not found).

**Concurrency**: The Moka cache is thread-safe. Multiple concurrent requests for the same person_id will each check the cache independently. On cache miss, both will call the projection client (duplicate reads), but only the first to complete will populate the cache. This is acceptable - a few duplicate reads are cheaper than cache locking overhead.

**Memory management**: The cache has a max capacity (configured in settings). When full, Moka evicts least-recently-used entries. PersonSummaryData is ~1-2KB per entry, so 10,000 cached persons = ~10-20MB memory, which is acceptable.

## Usage Examples

**From API handler**:

```rust
let result = person_service
    .get_person_summary(&person_id, &auth.agency_id)
    .await?;

match result {
    Some((person_data, cache_hit)) => {
        // Log query audit
        query_auditor.log_person_query(&person_id, &auth.agency_id, cache_hit).await?;
        // Return 200 OK with person data
        Ok(Json(person_data))
    }
    None => {
        // Return 404 Not Found
        Err(AppError::NotFound)
    }
}
```
````

**Cache invalidation** (for future use):

```rust
person_service.invalidate_cache(&person_id, &agency_id);
```

## Related Code

- `infra/projections/kurrent_client.rs` - Reads and folds events from EventStore
- `infra/projections/client.rs` - ProjectionClient trait (abstraction)
- `domain/models/person_summary.rs` - PersonSummaryData struct definition
- `api/handlers/persons.rs` - HTTP handler that calls this service
- `tests/person_service.rs` - Unit tests for cache hit/miss behavior
- `domain/errors.rs` - QueryError type for error handling

```

### Example 3: Deep explanation for senior audience

**Command**: `/explain src/middleware/auth.rs --depth=deep --audience=senior`

**Output**: (Would be 10+ paragraphs covering JWT validation flow, security considerations, error handling, performance implications, multi-tenancy enforcement, token refresh handling, etc.)

## Validation

Before presenting explanation:

- [ ] Code reference resolved successfully
- [ ] Context gathered from CLAUDE.md, README, related files
- [ ] Explanation follows structure for chosen depth
- [ ] Language appropriate for chosen audience
- [ ] Examples are concrete and accurate
- [ ] Related code links are relevant and helpful
- [ ] Technical details are correct
- [ ] Trade-offs explained (if depth=standard or deep)
- [ ] Security/performance implications noted (if audience=senior)

## Context

Additional user context: $ARGUMENTS
```
