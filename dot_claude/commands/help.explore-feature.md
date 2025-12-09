---
description: Explore and map a feature by code reference (file/function/variable) or natural language description
allowed-tools: Read, Grep, Glob, Task
argument-hint: "<code-reference or feature-description> [--format=map|list|graph] [--depth=shallow|standard|deep]"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command explores a feature by either analyzing code references (file names, function names, variable names) or by understanding natural language feature descriptions. It maps out all related code, dependencies, data flow, and provides a comprehensive overview of how the feature works.

### Execution Steps

1. **Parse Arguments and Identify Exploration Type**:

   **Input types**:

   **A. Code Reference** (specific code element):
   - File name: `/explore-feature person_service.rs`
   - Function: `/explore-feature PersonQueryService::get_person_summary`
   - Variable/field: `/explore-feature cache_key`
   - Type/struct: `/explore-feature PersonSummaryData`
   - Module: `/explore-feature domain::services`

   **B. Natural Language** (feature description):
   - `/explore-feature "person query caching"`
   - `/explore-feature "JWT authentication"`
   - `/explore-feature "how does multi-tenancy work"`
   - `/explore-feature "query audit logging"`

   **Flags**:
   - `--format=map` (hierarchical map, default)
   - `--format=list` (flat list of files)
   - `--format=graph` (dependency graph with relationships)
   - `--depth=shallow` (direct dependencies only)
   - `--depth=standard` (2-3 levels deep, default)
   - `--depth=deep` (full transitive closure)

2. **Determine Search Strategy**:

   **If code reference**:
   - Strategy: Direct search for exact matches
   - Tools: Grep for definitions and usages

   **If natural language**:
   - Strategy: Keyword extraction → search → relevance filtering
   - Tools: Grep for related terms, analyze results

   a. **For code reference, identify element type**:

   **File reference** (ends with file extension):
   - Search: `find . -name "person_service.rs"`
   - Entry point: The file itself

   **Function/method reference** (contains `::`):
   - Search: `grep -r "fn get_person_summary"` or `grep -r "pub async fn get_person_summary"`
   - Entry point: Function definition

   **Variable reference** (simple name):
   - Search: `grep -r "let cache_key"` or `grep -r "cache_key"`
   - Entry point: Variable usage locations

   **Type reference** (PascalCase name):
   - Search: `grep -r "struct PersonSummaryData"` or `grep -r "PersonSummaryData"`
   - Entry point: Type definition

   b. **For natural language, extract keywords**:

   Example: "person query caching"
   - Keywords: `person`, `query`, `cache`, `caching`
   - Search for files/functions mentioning these terms
   - Rank by relevance (how many keywords match)

3. **Find Entry Points**:

   a. **Search codebase**:
   - Use Grep to find all matches
   - If multiple matches, rank by relevance
   - Identify primary entry point (most central to feature)

   b. **For code reference**:

   ```bash
   # Example: PersonQueryService::get_person_summary
   grep -rn "fn get_person_summary" src/
   # Result: src/domain/services/person_service.rs:78
   ```

   c. **For natural language**:

   ```bash
   # Example: "JWT authentication"
   grep -rn "jwt\|JWT\|auth" src/ | grep -v test
   # Filter results for most relevant
   # Primary: src/middleware/auth.rs
   ```

   d. **Read primary entry point**:
   - Read the file containing entry point
   - Understand its role in the system
   - Identify related components

4. **Map Related Code**:

   **Build comprehensive feature map**:

   a. **Direct dependencies** (what this code uses):

   **Imports/uses**:
   - Parse import statements
   - Identify external crates
   - Identify internal modules

   **Function calls**:
   - Find all function calls in implementation
   - Note which modules they belong to

   **Type references**:
   - Identify types used (parameters, returns, fields)
   - Note where types are defined

   Example for `PersonQueryService::get_person_summary`:

   ```
   Direct dependencies:
   - ProjectionClient trait (infra/projections/client.rs)
   - PersonSummaryData model (domain/models/person_summary.rs)
   - QueryError type (domain/errors.rs)
   - Moka cache (external crate)
   ```

   b. **Reverse dependencies** (what uses this code):

   **Callers**:
   - Search for usages of function/type
   - Identify where this code is called from

   Example:

   ```bash
   grep -rn "get_person_summary" src/
   # Found in: api/handlers/persons.rs:45
   ```

   ```
   Reverse dependencies (callers):
   - get_person handler (api/handlers/persons.rs)
   - Integration tests (tests/integration/person_api.rs)
   ```

   c. **Sibling components** (related parts of same feature):

   **Same module**:
   - Other functions in same file
   - Other methods on same struct

   **Related modules**:
   - Models used by this service
   - Handlers that call this service
   - Tests for this component

   Example:

   ```
   Sibling components:
   - PersonQueryService::invalidate_cache (same struct)
   - OperationQueryService (similar pattern)
   - get_person handler (API layer)
   - person_service tests (test coverage)
   ```

   d. **Data flow** (how data moves through feature):

   **Data sources**:
   - Where does data come from?
   - HTTP request, database, cache, config?

   **Data transformations**:
   - How is data modified?
   - Parsing, validation, mapping?

   **Data sinks**:
   - Where does data go?
   - HTTP response, database, logs?

   Example:

   ```
   Data flow for person query:
   1. HTTP Request → person_id (path param), agency_id (JWT)
   2. Handler extracts parameters
   3. Service checks cache (Moka)
   4. Service reads EventStore (if cache miss)
   5. Service folds events into PersonSummaryData
   6. Service caches result
   7. Handler logs query (QueryAuditor)
   8. HTTP Response ← PersonSummaryData JSON
   ```

   e. **Control flow** (execution paths):

   **Conditional branches**:
   - Cache hit vs cache miss
   - Found vs not found
   - Success vs error

   **Error paths**:
   - What errors can occur?
   - How are they handled?

5. **Build Feature Map**:

   **Organize discovered components by layer/role**:

   a. **Categorize components**:

   **Entry points**:
   - API handlers
   - Public functions
   - CLI commands

   **Business logic**:
   - Domain services
   - Business rules
   - Validation

   **Data access**:
   - Repository implementations
   - Database clients
   - Cache clients

   **Models**:
   - Domain models
   - DTOs
   - Request/response types

   **Infrastructure**:
   - External service clients
   - Configuration
   - Utilities

   **Tests**:
   - Unit tests
   - Integration tests
   - End-to-end tests

   b. **Build hierarchical map**:

   ```
   Person Query Feature
   │
   ├── API Layer
   │   ├── Route: GET /v1/persons/{id} (api/routes/v1.rs:15)
   │   └── Handler: get_person (api/handlers/persons.rs:42)
   │
   ├── Domain Layer
   │   ├── Service: PersonQueryService (domain/services/person_service.rs:20)
   │   │   ├── get_person_summary (line 78)
   │   │   └── invalidate_cache (line 145)
   │   ├── Model: PersonSummaryData (domain/models/person_summary.rs:8)
   │   └── Error: QueryError (domain/errors.rs:12)
   │
   ├── Infrastructure Layer
   │   ├── ProjectionClient trait (infra/projections/client.rs:15)
   │   ├── KurrentProjectionClient impl (infra/projections/kurrent_client.rs:35)
   │   └── Cache: Moka (external crate)
   │
   ├── Middleware
   │   └── JWT Auth (middleware/auth.rs:25)
   │       └── Extracts agency_id for multi-tenancy
   │
   ├── Audit
   │   └── QueryAuditor (domain/queries/audit.rs:45)
   │       └── Logs to query-journal-{agency_id} stream
   │
   └── Tests
       ├── Unit: person_service tests (tests/person_service.rs)
       └── Integration: person API tests (tests/integration/person_api.rs)
   ```

6. **Analyze Feature Characteristics**:

   a. **Complexity metrics**:
   - Number of files involved
   - Lines of code
   - Number of dependencies
   - Cyclomatic complexity (if calculable)

   b. **Architecture patterns**:
   - Identify patterns used (Service Layer, Repository, etc.)
   - Note adherence to project architecture

   c. **Cross-cutting concerns**:
   - Logging/tracing
   - Error handling
   - Authentication/authorization
   - Caching
   - Validation

   d. **Performance characteristics**:
   - Caching strategy
   - Database queries
   - Network calls
   - Potential bottlenecks

7. **Generate Exploration Report**:

   ```markdown
   # Feature Exploration: Person Query

   **Entry Point**: `PersonQueryService::get_person_summary`
   **Feature Type**: CQRS Query with Caching
   **Complexity**: Medium (8 files, ~350 LOC)

   ## Quick Summary

   This feature implements the query side of CQRS for person data, providing
   a cached read path from EventStore projections. It enforces multi-tenancy
   by filtering events by agency_id and logs all queries for audit compliance.

   ---

   ## Feature Map

   ### API Layer

   **Route**: `GET /v1/persons/{id}`

   - **File**: `api/routes/v1.rs:15`
   - **Handler**: `get_person` → `api/handlers/persons.rs:42`

   **Handler**: `get_person()`

   - **Purpose**: HTTP entry point for person queries
   - **Inputs**: person_id (path param), agency_id (JWT claim)
   - **Dependencies**:
     - PersonQueryService (domain service)
     - QueryAuditor (audit logging)
     - AuthContext (from middleware)
   - **Outputs**: JSON (PersonSummaryData) or 404

   ---

   ### Domain Layer

   **Service**: `PersonQueryService`

   - **File**: `domain/services/person_service.rs:20`
   - **Purpose**: Orchestrate person queries with caching
   - **Pattern**: Service Layer

   **Methods**:

   1. `get_person_summary(person_id, agency_id)` (line 78)
      - Check Moka cache (24h TTL)
      - On miss: read from ProjectionClient
      - Cache result
      - Return (data, cache_hit_flag)

   2. `invalidate_cache(person_id, agency_id)` (line 145)
      - Remove entry from cache
      - Used after person updates

   **Dependencies**:

   - `ProjectionClient` trait (reads projections)
   - `PersonSummaryData` model
   - `QueryError` type
   - `Moka` cache

   **Model**: `PersonSummaryData`

   - **File**: `domain/models/person_summary.rs:8`
   - **Purpose**: Person projection data structure
   - **Fields**: person_id, name, email, agency_id, created_at, ...

   **Error Type**: `QueryError`

   - **File**: `domain/errors.rs:12`
   - **Variants**: Projection, Infrastructure, Validation

   ---

   ### Infrastructure Layer

   **Trait**: `ProjectionClient`

   - **File**: `infra/projections/client.rs:15`
   - **Purpose**: Abstract projection reading
   - **Method**: `read_projection(type, id, agency_id)`

   **Implementation**: `KurrentProjectionClient`

   - **File**: `infra/projections/kurrent_client.rs:35`
   - **Purpose**: Read projections from EventStore
   - **Strategy**:
     1. Read stream "person-{id}"
     2. Filter events by metadata.agency_id
     3. Fold events into PersonSummaryData JSON
     4. Return projection or None

   **Cache**: Moka (external crate)

   - In-memory, thread-safe
   - 24-hour TTL
   - Key format: "person:{agency_id}:{person_id}"

   ---

   ### Cross-Cutting Concerns

   **Authentication/Multi-Tenancy**:

   - **Middleware**: `middleware/auth.rs:25`
   - **Purpose**: Extract agency_id from JWT
   - **Used by**: Handler (AuthContext extension)
   - **Enforcement**: Events filtered by agency_id

   **Audit Logging**:

   - **Service**: `QueryAuditor`
   - **File**: `domain/queries/audit.rs:45`
   - **Purpose**: Log all queries for compliance
   - **Destination**: EventStore stream `query-journal-{agency_id}`
   - **Data logged**: query type, person_id, agency_id, cache_hit, timestamp

   **Error Handling**:

   - Domain errors (QueryError) converted to HTTP errors (AppError)
   - 404 for not found (including cross-agency queries)
   - 500 for infrastructure failures

   **Logging/Tracing**:

   - Structured logging with `tracing` crate
   - Query execution logged
   - Errors logged with context

   ---

   ## Data Flow Diagram
   ```

   HTTP Request (GET /v1/persons/123)
   ↓
   [Auth Middleware]
   ├─ Extract JWT
   ├─ Validate signature
   └─ Extract agency_id → AuthContext
   ↓
   [Handler: get_person]
   ├─ Extract person_id from path
   └─ Call PersonQueryService
   ↓
   [PersonQueryService::get_person_summary]
   ├─ Construct cache_key: "person:{agency_id}:{person_id}"
   ├─ Check Moka cache
   ├─ CACHE HIT? → Return (data, true)
   ├─ CACHE MISS ↓
   ├─ Call ProjectionClient::read_projection
   │ ↓
   │ [KurrentProjectionClient]
   │ ├─ Read EventStore stream "person-123"
   │ ├─ Filter events: metadata.agency_id == agency_id
   │ ├─ Fold events → PersonSummaryData
   │ └─ Return Some(data) or None
   │ ↓
   ├─ Cache result (if Some)
   └─ Return (data, false)
   ↓
   [Handler: get_person]
   ├─ Match on result
   ├─ Some(data, cache_hit):
   │ ├─ Call QueryAuditor::log_person_query
   │ └─ Return 200 OK with JSON
   └─ None:
   └─ Return 404 Not Found

   ```

   ---

   ## Control Flow

   ### Happy Path (Cache Hit)
   1. Request arrives
   2. JWT validated, agency_id extracted
   3. Cache hit (data found in Moka)
   4. Query logged to audit stream
   5. Response: 200 OK with PersonSummaryData

   **Latency**: ~100μs (in-memory cache)

   ### Happy Path (Cache Miss)
   1. Request arrives
   2. JWT validated, agency_id extracted
   3. Cache miss
   4. EventStore stream read (person-123)
   5. Events filtered by agency_id
   6. Events folded into PersonSummaryData
   7. Result cached
   8. Query logged to audit stream
   9. Response: 200 OK with PersonSummaryData

   **Latency**: ~5-50ms (EventStore read + folding)

   ### Not Found Path
   1. Request arrives
   2. JWT validated, agency_id extracted
   3. Cache miss
   4. EventStore stream read
   5. No events (stream missing OR all filtered out)
   6. Return None
   7. Response: 404 Not Found

   **Note**: Returns 404 for both "person doesn't exist" AND "person exists
   but belongs to different agency" (security: don't leak existence info)

   ### Error Path
   1. Request arrives
   2. JWT validated, agency_id extracted
   3. Cache miss
   4. EventStore connection failure
   5. Return QueryError::Infrastructure
   6. Converted to AppError
   7. Response: 500 Internal Server Error

   ---

   ## Related Features

   **Similar patterns**:
   - **Operation Query**: Similar CQRS query pattern (no caching)
     - Entry: `GET /v1/operations/{id}`
     - Service: `OperationQueryService`

   **Dependencies**:
   - **JWT Authentication**: Required for multi-tenancy
   - **EventStore**: Data source for projections
   - **Query Audit**: Compliance logging

   **Related commands** (hypothetical):
   - Person creation (command side)
   - Person update (command side)
   - Cache invalidation (after updates)

   ---

   ## Tests

   ### Unit Tests
   **File**: `tests/person_service.rs`

   **Test cases**:
   - `test_get_person_summary_cache_hit` - Verify cache returns cached data
   - `test_get_person_summary_cache_miss` - Verify projection read on miss
   - `test_get_person_summary_not_found` - Verify None handling
   - `test_invalidate_cache` - Verify cache invalidation

   **Mocking**: Uses MockProjectionClient

   ### Integration Tests
   **File**: `tests/integration/person_api.rs`

   **Test cases**:
   - `test_get_person_success` - End-to-end happy path
   - `test_get_person_not_found` - 404 response
   - `test_get_person_cross_agency_denied` - Multi-tenancy filtering
   - `test_get_person_cache_behavior` - Cache hit/miss

   **Requirements**: Running EventStore instance

   ---

   ## Complexity Metrics

   - **Files involved**: 8
   - **Total LOC**: ~350
   - **Dependencies**: 6 (ProjectionClient, PersonSummaryData, QueryError, Cache, AuthContext, QueryAuditor)
   - **Reverse dependencies**: 2 (handler, tests)
   - **External crates**: 2 (Moka, EventStore client)
   - **Cyclomatic complexity**: Low-Medium (mostly linear flow with cache branch)

   ---

   ## Architecture Patterns

   **Patterns identified**:
   - ✅ **Service Layer**: Domain service separates business logic from handlers
   - ✅ **Repository Pattern**: ProjectionClient abstracts data access
   - ✅ **Dependency Injection**: Services injected via AppState
   - ✅ **Cache-Aside**: Check cache, on miss read DB and cache
   - ✅ **CQRS**: Separate read path (this) from write path (commands)
   - ✅ **Multi-Tenancy**: Agency-id filtering at multiple layers

   **Adherence to project architecture**: High (follows CLAUDE.md conventions)

   ---

   ## Performance Characteristics

   **Caching**:
   - Strategy: Cache-aside with 24h TTL
   - Hit rate: Estimated ~80-90% (person data changes infrequently)
   - Memory: ~1-2KB per cached person
   - Eviction: LRU when cache full

   **Database Queries**:
   - EventStore stream read: 1 query per cache miss
   - Query complexity: O(n) where n = number of events in stream
   - Typical: 1-10 events per person

   **Network Calls**:
   - EventStore: 1 call per cache miss
   - None on cache hit

   **Potential Bottlenecks**:
   - EventStore latency on cache miss
   - Event folding for persons with many events
   - Cache contention (mitigated by lock-free Moka)

   ---

   ## Suggested Exploration Next

   Based on this feature, you might want to explore:

   1. **Multi-tenancy implementation**:
      `/explore-feature "multi-tenancy filtering"`

   2. **Query audit logging**:
      `/explore-feature QueryAuditor`

   3. **EventStore projection reading**:
      `/explore-feature KurrentProjectionClient`

   4. **Similar feature (Operation queries)**:
      `/explore-feature OperationQueryService`

   5. **JWT authentication**:
      `/explore-feature middleware/auth.rs`
   ```

8. **Alternative Output Formats**:

   **List format** (--format=list):

   ```
   # Person Query Feature - File List

   API Layer:
   - api/routes/v1.rs:15 (route definition)
   - api/handlers/persons.rs:42 (get_person handler)

   Domain Layer:
   - domain/services/person_service.rs:20 (PersonQueryService)
   - domain/models/person_summary.rs:8 (PersonSummaryData)
   - domain/errors.rs:12 (QueryError)

   Infrastructure Layer:
   - infra/projections/client.rs:15 (ProjectionClient trait)
   - infra/projections/kurrent_client.rs:35 (KurrentProjectionClient)

   Middleware:
   - middleware/auth.rs:25 (JWT authentication)

   Audit:
   - domain/queries/audit.rs:45 (QueryAuditor)

   Tests:
   - tests/person_service.rs (unit tests)
   - tests/integration/person_api.rs (integration tests)

   Total: 10 files
   ```

   **Graph format** (--format=graph):

   ```
   # Person Query Feature - Dependency Graph

   get_person (handler)
       ├── depends on → PersonQueryService
       │   ├── depends on → ProjectionClient (trait)
       │   │   └── implemented by → KurrentProjectionClient
       │   │       └── depends on → EventStore
       │   ├── depends on → PersonSummaryData (model)
       │   ├── depends on → QueryError (type)
       │   └── depends on → Moka (cache)
       ├── depends on → QueryAuditor
       │   └── depends on → EventStore
       └── depends on → AuthContext
           └── depends on → JWT middleware

   PersonQueryService
       ├── called by → get_person (handler)
       ├── called by → tests (person_service.rs)
       └── called by → integration tests (person_api.rs)
   ```

9. **Validation**:

   **Before generating report**:
   - [ ] Entry point identified
   - [ ] Direct dependencies discovered
   - [ ] Reverse dependencies discovered
   - [ ] Data flow mapped
   - [ ] Control flow analyzed
   - [ ] All files read successfully
   - [ ] Components categorized by layer

## Edge Cases & Error Handling

**Ambiguous reference**:

- If multiple matches, list all and ask user to clarify
- Example: "Found 3 functions named 'parse', please specify:"

**No matches found**:

- Suggest similar names (fuzzy matching)
- Offer to search with relaxed criteria
- Ask if user wants to explore related feature

**Natural language too vague**:

- Ask for clarification
- Suggest adding more specific keywords
- Show top 5 matches and let user pick

**Very large feature** (50+ files):

- Warn about complexity
- Offer to limit depth
- Suggest exploring sub-components separately

**External dependencies**:

- Note external crates but don't explore their internals
- Link to crate documentation
- Focus on how the feature uses the dependency

## Examples

### Example 1: Explore by function name

**Command**: `/explore-feature PersonQueryService::get_person_summary`

**Output**: (Generates comprehensive report as shown in step 7)

### Example 2: Explore by natural language

**Command**: `/explore-feature "JWT authentication"`

**Output**:

```
Searching for "JWT authentication"...

Found 1 primary component:
- middleware/auth.rs (JWT validation middleware)

Analyzing feature...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Feature Exploration: JWT Authentication

**Entry Point**: `middleware/auth.rs`
**Feature Type**: Authentication Middleware
**Complexity**: Low (2 files, ~120 LOC)

## Quick Summary

This feature implements JWT token validation middleware for Axum,
extracting and validating JWTs from Authorization headers and populating
an AuthContext with agency_id and actor_id for multi-tenancy enforcement.

[... detailed exploration similar to person query example ...]
```

### Example 3: List format

**Command**: `/explore-feature person_service.rs --format=list`

**Output**: (Shows file list as in step 8)

### Example 4: Shallow exploration

**Command**: `/explore-feature PersonQueryService --depth=shallow`

**Output**:

```
# Feature Exploration: PersonQueryService (Shallow)

**Entry Point**: domain/services/person_service.rs:20
**Direct dependencies only**

## Direct Dependencies

Uses:
- ProjectionClient trait (infra/projections/client.rs)
- PersonSummaryData model (domain/models/person_summary.rs)
- QueryError type (domain/errors.rs)
- Moka cache (external crate)

Used by:
- get_person handler (api/handlers/persons.rs)
- person_service tests (tests/person_service.rs)

Total files: 5

For deeper exploration, run:
  /explore-feature PersonQueryService --depth=standard
```

## Context

Additional user context: $ARGUMENTS
