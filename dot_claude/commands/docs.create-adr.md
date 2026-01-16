---
description: Create an Architecture Decision Record (ADR) documenting a design decision with context, alternatives, and consequences
allowed-tools: Read, Write, Bash
argument-hint: <decision-title> [--number N]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command creates an Architecture Decision Record (ADR) following the standard ADR format, documenting important architectural and design decisions with their context, alternatives considered, and consequences.

### Execution Steps

1. **Parse Arguments**:
   - Extract decision title from $ARGUMENTS
   - Extract optional ADR number (--number N)
   - If no title provided: ERROR "Please provide decision title: /adr-create <title>"

2. **Locate ADR Directory**:
   - Check for existing ADR directory:
     - `docs/adr/`
     - `doc/architecture/decisions/`
     - `.adr/`
     - `architecture/decisions/`
   - If none exists, create `docs/adr/`
   - Report location to user

3. **Determine ADR Number**:
   - If --number provided, use that
   - Otherwise, find highest existing ADR number and increment
   - List existing ADRs in directory: `NNNN-*.md`
   - Extract numbers, find max, add 1
   - If no ADRs exist, start with 0001
   - Format as 4-digit: 0001, 0002, etc.

4. **Create ADR Filename**:
   - Format: `NNNN-decision-title-in-kebab-case.md`
   - Convert title to kebab-case (lowercase, hyphens)
   - Example: "Use Moka for Caching" → `0005-use-moka-for-caching.md`

5. **Gather Context**:
   - Read project CLAUDE.md for architecture context
   - Read README.md for project overview
   - Check for related ADRs that might be referenced
   - Identify current technologies and patterns

6. **Interactive ADR Creation**:

   Engage with user to gather information for each ADR section:

   **a. Status** (select one):
   - Proposed (decision under discussion)
   - Accepted (decision approved and implemented)
   - Deprecated (decision superseded)
   - Superseded (replaced by another ADR)

   Ask user: "What is the status of this decision? (proposed/accepted/deprecated/superseded)"

   **b. Context** (gather details):
   - What problem are we solving?
   - What constraints exist?
   - What forces are at play?
   - Why is this decision needed now?

   Ask user: "What is the context and problem this decision addresses? (2-4 sentences)"

   **c. Decision** (the choice made):
   - What did we decide to do?
   - Be specific and concrete

   Ask user: "What is the decision? State it clearly and concisely. (1-3 sentences)"

   **d. Alternatives Considered**:
   - What other options were evaluated?
   - Why were they rejected?

   Ask user: "What alternatives did you consider? List 2-4 with brief reasons for rejection."

   Format as:
   - Alternative 1: [Description] - Rejected because [reason]
   - Alternative 2: [Description] - Rejected because [reason]

   **e. Consequences** (implications):
   - Positive consequences (benefits)
   - Negative consequences (costs, tradeoffs)
   - Neutral consequences (changes, impacts)

   Ask user: "What are the consequences of this decision? Include positive (benefits), negative (tradeoffs), and neutral (impacts)."

   **f. Additional Sections** (optional):

   Ask user: "Do you want to include any of these optional sections? (yes/no for each)"
   - Implementation notes
   - Related decisions (links to other ADRs)
   - References (external docs, articles)

7. **Generate ADR File**:

   Use this template structure:

   ```markdown
   # [ADR Number]. [Decision Title]

   **Date**: [YYYY-MM-DD]

   **Status**: [Proposed/Accepted/Deprecated/Superseded]

   [If Superseded: Superseded by [ADR-NNNN](NNNN-title.md)]

   ---

   ## Context

   [Context paragraph explaining the problem and forces]

   [Additional context if needed]

   ## Decision

   [Clear statement of the decision]

   [Additional details about the decision]

   ## Alternatives Considered

   ### [Alternative 1 Name]

   [Description of alternative]

   **Rejected because**: [Reason for rejection]

   ### [Alternative 2 Name]

   [Description of alternative]

   **Rejected because**: [Reason for rejection]

   [Additional alternatives as needed]

   ## Consequences

   ### Positive

   - [Benefit 1]
   - [Benefit 2]
   - [Benefit 3]

   ### Negative

   - [Tradeoff 1]
   - [Tradeoff 2]

   ### Neutral

   - [Impact 1]
   - [Impact 2]

   ## Implementation Notes

   [If provided: specific guidance for implementing this decision]

   ## Related Decisions

   [If applicable: links to related ADRs]

   - [ADR-NNNN](NNNN-title.md) - [Brief description of relationship]

   ## References

   [If applicable: external resources]

   - [Resource title](URL) - [Brief description]
   - [Article/Doc title] - [Why relevant]

   ---

   **Authors**: [@username]

   **Reviewers**: [To be added during review]
   ```

8. **Write ADR File**:
   - Create file at `[adr-dir]/NNNN-title.md`
   - Use generated content
   - Validate markdown formatting
   - Ensure proper heading hierarchy

9. **Update ADR Index** (if exists):
   - Check for `docs/adr/README.md` or `docs/adr/index.md`
   - If exists, add entry for new ADR:

     ```markdown
     - [ADR-NNNN: Title](NNNN-title.md) - [Status] - [Date]
     ```

   - Keep chronological order
   - If index doesn't exist, offer to create one

10. **Report Results**:

    ```
    ✅ ADR created: [path-to-adr-file]

    📋 ADR Details:
    - Number: NNNN
    - Title: [Decision Title]
    - Status: [Status]
    - File: [filename]

    📝 Next Steps:
    1. Review ADR content for completeness
    2. Share with team for feedback
    3. Update status when decision is made
    4. Reference this ADR in related code/docs
    5. Link from README or architecture docs

    💡 Tip: Use `/adr-create` for future decisions to maintain consistency
    ```

## ADR Best Practices

### When to Create an ADR

Create an ADR for decisions that:

✅ **Structural Impact**:

- Affect system architecture
- Define integration patterns
- Establish data flow strategies
- Choose core technologies

✅ **Significant Tradeoffs**:

- Have notable pros and cons
- Impact multiple concerns (performance, maintainability, security)
- Involve accepting technical debt
- Require choosing between valid alternatives

✅ **Team Alignment**:

- Need broad team consensus
- Affect multiple teams or services
- Establish conventions or standards
- Define boundaries or responsibilities

✅ **Long-Term Impact**:

- Difficult or costly to reverse
- Set precedent for future decisions
- Affect scalability or evolution
- Define public APIs or contracts

❌ **Don't Create ADRs For**:

- Implementation details (which library version)
- Temporary solutions
- Tactical coding decisions
- Easily reversible choices
- Personal preferences without technical rationale

### Writing Good ADRs

**Context Section**:

- Focus on forces and constraints, not solutions
- Explain why the decision is needed
- Provide enough background for readers unfamiliar with the problem
- Include relevant technical or business constraints

**Decision Section**:

- Be specific and concrete
- State what will be done, not what might be done
- Include enough detail to guide implementation
- Avoid vague language ("we should consider", "might be good")

**Alternatives Section**:

- List serious contenders (not strawmen)
- Explain why each was rejected with technical reasoning
- Acknowledge tradeoffs honestly
- Note if an alternative might be better in different circumstances

**Consequences Section**:

- Be honest about negatives (technical debt, complexity, cost)
- Quantify impacts when possible (performance, development time)
- Include operational consequences (deployment, monitoring, debugging)
- Note reversibility: Can this decision be changed later?

### ADR Statuses

**Proposed**:

- Decision under discussion
- Not yet approved
- Gathering feedback
- May change before acceptance

**Accepted**:

- Decision approved by team/stakeholders
- Ready for implementation
- Becomes the standard
- Can still be superseded later

**Deprecated**:

- No longer recommended
- Better alternative exists
- Being phased out
- Should link to replacement ADR

**Superseded**:

- Replaced by newer ADR
- Original decision no longer applies
- Must link to superseding ADR
- Kept for historical context

### Numbering Conventions

**Sequential Numbering** (Recommended):

- 0001, 0002, 0003, etc.
- Chronological order
- Shows evolution of decisions
- Easy to reference

**Date-Based Numbering**:

- YYYYMMDD-title.md
- Sortable by date
- Obvious when decision was made
- Can have multiple ADRs per day (add suffix)

**This command uses sequential numbering** for simplicity and common practice.

### ADR Organization

**Directory Structure**:

```
docs/adr/
├── README.md (index of all ADRs)
├── 0001-use-rust-for-query-service.md
├── 0002-implement-cqrs-pattern.md
├── 0003-use-kurrentdb-for-event-store.md
├── 0004-multi-tenancy-via-jwt.md
└── 0005-use-moka-for-caching.md
```

**Index File** (README.md):

```markdown
# Architecture Decision Records

## Overview

This directory contains Architecture Decision Records (ADRs) documenting
key architectural and design decisions for this project.

## ADR Format

We use the format described at https://adr.github.io/

## Index

- [ADR-0001: Use Rust for Query Service](0001-use-rust-for-query-service.md) - Accepted - 2025-01-15
- [ADR-0002: Implement CQRS Pattern](0002-implement-cqrs-pattern.md) - Accepted - 2025-01-20
- [ADR-0003: Use KurrentDB for Event Store](0003-use-kurrentdb-for-event-store.md) - Accepted - 2025-01-25
- [ADR-0004: Multi-Tenancy via JWT](0004-multi-tenancy-via-jwt.md) - Accepted - 2025-02-01
- [ADR-0005: Use Moka for Caching](0005-use-moka-for-caching.md) - Proposed - 2025-02-10
```

## Example ADRs

### Example 1: Technology Choice

```markdown
# ADR-0005. Use Moka for In-Memory Caching

**Date**: 2025-02-10

**Status**: Accepted

---

## Context

PersonSummary queries are the highest-frequency read operation in leads-queries
(>10K req/min during peak). Each query reads and folds events from KurrentDB,
averaging 200ms per request. Analytics show an 80/20 access pattern: 80% of
queries target 20% of persons, and person data changes infrequently (<1% daily).

Current EventStore CPU utilization reaches 45% during peak hours, limiting
horizontal scaling. We need caching to reduce load and improve response times
before reaching 100K concurrent users milestone.

Constraints:

- Single-instance deployment (no distributed cache needed yet)
- Must enforce multi-tenancy (no cross-agency data leaks)
- Rust-native solution preferred (team expertise)
- TTL-based expiration required

## Decision

We will use Moka (https://github.com/moka-rs/moka) for in-memory caching of
PersonSummary projections with 24-hour TTL. Cache keys will include agency_id
to enforce multi-tenancy: `person:{agency_id}:{person_id}`.

Cache-aside pattern: check cache → on miss, read from EventStore → populate cache.

Manual invalidation API will be provided for immediate updates:
`POST /v1/persons/{id}/cache/invalidate`

## Alternatives Considered

### Redis (Distributed Cache)

External Redis instance for caching.

**Rejected because**:

- Adds network latency (1-5ms) vs in-memory (<1ms)
- Operational complexity (separate service to manage)
- Not needed yet (single instance sufficient for current scale)
- May revisit when we need multi-instance horizontal scaling

### Longer TTL (7 days)

Keep 24h TTL decision but extend to 7 days.

**Rejected because**:

- Data freshness concerns for critical business data
- Current 24h TTL provides 95%+ hit rate (analytics)
- Marginal cache hit improvement doesn't justify staleness risk

### No Caching (Optimize EventStore Queries)

Improve query performance without caching.

**Rejected because**:

- EventStore read performance limited by event folding
- 80/20 access pattern makes caching highly effective
- Vertical scaling alone won't achieve <10ms p99 target

## Consequences

### Positive

- Response time improvement: 200ms → <1ms for cache hits (99.5% faster)
- EventStore CPU reduction: 45% → ~12% average (73% reduction)
- Enables scaling to 100K concurrent users without additional EventStore capacity
- Rust-native, well-maintained library (good developer experience)
- Thread-safe, lock-free implementation (no contention issues)

### Negative

- Memory usage: Unbounded cache size (need monitoring, future size limits)
- Cache invalidation complexity for immediate updates
- Eventual consistency: 24h staleness possible for rarely-accessed persons
- Single point of failure: Cache loss = all requests hit EventStore temporarily

### Neutral

- Manual invalidation API required (adds endpoint, documentation)
- Future migration to Redis feasible (ProjectionClient abstraction)
- Monitoring needed for cache hit rate, memory usage
- Event-based invalidation possible future enhancement

## Implementation Notes

1. Add Moka dependency: `moka = "0.12"` to Cargo.toml
2. Create cache in `PersonQueryService::new()` with 24h TTL
3. Cache key format: `person:{agency_id}:{person_id}`
4. Return `cache_hit: bool` flag in API responses for monitoring
5. Implement `POST /v1/persons/{id}/cache/invalidate` endpoint
6. Add cache hit/miss metrics to observability dashboard
7. Document cache behavior in CLAUDE.md and API docs

## Related Decisions

- [ADR-0002](0002-implement-cqrs-pattern.md) - CQRS pattern enables read-side caching
- [ADR-0004](0004-multi-tenancy-via-jwt.md) - Multi-tenancy requires agency_id in cache keys

## References

- [Moka Documentation](https://github.com/moka-rs/moka)
- [Cache-Aside Pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside)
- Analytics Report: PersonSummary Query Patterns (internal doc)

---

**Authors**: @tech-lead

**Reviewers**: @backend-team, @devops
```

### Example 2: Architectural Pattern

```markdown
# ADR-0002. Implement CQRS Pattern

**Date**: 2025-01-20

**Status**: Accepted

---

## Context

The leads management system has divergent read and write requirements:

**Write Side**:

- Complex business rules and validation
- Event sourcing for audit trail
- Optimized for consistency and correctness
- Low throughput (<100 writes/min)

**Read Side**:

- Simple queries by ID or filters
- High throughput (>10K reads/min)
- Optimized for performance and availability
- Eventual consistency acceptable

Combining reads and writes in a single service leads to:

- Conflicting optimization goals (consistency vs performance)
- Complex models serving both use cases poorly
- Difficult scaling (reads and writes scale differently)
- Tight coupling between command and query logic

## Decision

We will implement Command Query Responsibility Segregation (CQRS) pattern with
separate services:

**leads-commands** (Write Service):

- Handles create, update, delete operations
- Enforces business rules and validation
- Appends events to KurrentDB event streams
- Optimized for correctness and consistency

**leads-queries** (Read Service):

- Handles read operations (get by ID, list, search)
- Reads pre-materialized projections from event streams
- Optimized for performance and scalability
- Eventual consistency with event store

Services communicate asynchronously via KurrentDB event streams, not direct calls.

## Alternatives Considered

### Traditional CRUD Service

Single service handling both reads and writes using traditional CRUD pattern.

**Rejected because**:

- Conflicting optimization goals (writes need consistency, reads need speed)
- Difficult to scale independently (read-heavy workload)
- Complex models trying to serve both use cases
- Event sourcing benefits lost (audit trail, temporal queries)

### Shared Database with Read Replicas

Single service with read replicas for query performance.

**Rejected because**:

- Doesn't separate concerns (same code for reads and writes)
- Read replicas lag behind master (consistency issues)
- Scaling limited by database replication
- Doesn't leverage event sourcing

### CQRS with Separate Projections Database

CQRS with projections in MongoDB instead of reading from event streams.

**Rejected for initial implementation because**:

- Additional operational complexity (MongoDB cluster)
- Not needed yet (event folding performance sufficient for current scale)
- May implement later as Phase 2 optimization
- Event stream as projection store is simpler for MVP

## Consequences

### Positive

- Independent scaling: Scale reads (10K req/min) separately from writes (100 req/min)
- Optimized models: PersonSummaryData for reads, Commands for writes
- Performance: Read-side caching without affecting write-side
- Flexibility: Can migrate read-side to MongoDB later without changing write-side
- Event sourcing benefits: Complete audit trail, temporal queries, event replay

### Negative

- Eventual consistency: Reads may not reflect latest writes immediately
- Operational complexity: Two services to deploy and monitor
- Data synchronization: Must ensure projections stay in sync with events
- Development overhead: More code than single service

### Neutral

- Service communication via events (KurrentDB), not REST calls
- Both services share event schemas (leads-schemas repository)
- Projection updates handled by consuming event streams
- Client must handle eventual consistency (UI polling or websockets)

## Implementation Notes

Phase 1 (Current):

- leads-commands: Command handlers, event appending
- leads-queries: Read projections from KurrentDB event streams
- Projections built on-demand via event folding

Phase 2 (Future):

- Projection manager: Write projections to MongoDB
- leads-queries: Read from MongoDB instead of event streams
- Faster queries, no event folding overhead

## Related Decisions

- [ADR-0001](0001-use-rust-for-query-service.md) - Technology choice for query service
- [ADR-0003](0003-use-kurrentdb-for-event-store.md) - Event store selection

## References

- [CQRS Pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs)
- [Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)
- Greg Young's CQRS Documents

---

**Authors**: @architect

**Reviewers**: @backend-team, @frontend-team
```

## Edge Cases & Error Handling

**No Title Provided**:

```
❌ Error: Decision title required

Usage: /adr-create <decision-title>
Example: /adr-create Use Moka for Caching
```

**ADR Directory Not Found**:

- Create `docs/adr/` by default
- Inform user of new directory
- Offer to create index/README

**Duplicate ADR Number**:

- If --number provided and file exists
- ERROR: "ADR-NNNN already exists: [filename]"
- Suggest using next available number or different title

**Invalid Number Format**:

- If --number not numeric
- ERROR: "Invalid ADR number. Must be integer: --number 5"

**User Cancels During Interactive Creation**:

- If user says "cancel" or "stop"
- Don't create file
- Optionally save draft for later completion

**Minimal Information Provided**:

- If user provides very brief responses
- Create ADR with available info
- Add TODO comments for incomplete sections
- Suggest reviewing and expanding later

## Validation

Before writing ADR file:

- [ ] Title is clear and descriptive
- [ ] ADR number is unique
- [ ] Status is valid (proposed/accepted/deprecated/superseded)
- [ ] Context section explains problem and forces
- [ ] Decision section is specific and actionable
- [ ] At least 2 alternatives listed with rejection reasons
- [ ] Consequences include positives and negatives
- [ ] Markdown formatting is valid
- [ ] Filename follows convention (NNNN-kebab-case.md)
- [ ] File path is correct (adr directory)

## Context

User-provided arguments: $ARGUMENTS

## Notes

- **ADRs are living documents**: Can be updated as understanding evolves
- **Link liberally**: Reference related ADRs, docs, code
- **Be honest**: Document tradeoffs and negatives, not just positives
- **Think long-term**: Future you will read this - provide context
- **Keep concise**: Aim for 1-2 pages, not exhaustive design docs
- **Date matters**: Include decision date for historical context
- **Status transitions**: Proposed → Accepted → Deprecated/Superseded
- **Version control**: ADRs are committed to git, showing evolution over time
