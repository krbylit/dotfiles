---
description: Generate comprehensive documentation for code including API docs, inline comments, and README sections
allowed-tools: Read, Grep, Glob, Write, Edit
argument-hint: "[target] [--type=inline|api|readme|architecture] [--style=brief|standard|detailed]"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command generates high-quality documentation by analyzing code structure, usage patterns, and project context. It produces inline documentation (doc comments), API documentation, README sections, and architecture overviews tailored to the project's conventions.

### Execution Steps

1. **Parse Arguments**:

   **Target** (required):
   - File path: `/docgen src/domain/person_service.rs`
   - Module path: `/docgen src/domain/services`
   - Function reference: `/docgen PersonQueryService::get_person_summary`
   - Entire project: `/docgen --all`

   **Type flags**:
   - `--type=inline` (doc comments for functions/types, default)
   - `--type=api` (API reference documentation)
   - `--type=readme` (README sections)
   - `--type=architecture` (architecture overview docs)
   - `--type=all` (generate all types)

   **Style flags**:
   - `--style=brief` (minimal docs, 1-2 lines)
   - `--style=standard` (comprehensive, default)
   - `--style=detailed` (exhaustive with examples)

   **Action flags**:
   - `--preview` (show docs without writing)
   - `--overwrite` (replace existing docs)
   - `--append` (add docs where missing, default)

2. **Gather Project Context**:

   **Critical for relevant, accurate documentation**:

   a. **Read existing documentation**:
   - `CLAUDE.md` - Project architecture, patterns, conventions
   - `README.md` - Project overview, setup instructions
   - Existing doc comments - Style and detail level
   - `docs/` directory - Architecture docs, ADRs

   b. **Understand documentation standards**:
   - Language-specific conventions:
     - Rust: `///` for public items, `//!` for modules
     - TypeScript: JSDoc `/** */` format
     - Python: Docstrings (Google/NumPy/Sphinx style)
     - Go: `//` comments above declarations
   - Project-specific conventions (from existing docs)
   - Required sections (e.g., "Safety", "Errors", "Examples")

   c. **Analyze target code**:
   - Read implementation
   - Read tests (show intended behavior)
   - Read callers (show usage patterns)
   - Identify edge cases, error conditions
   - Note performance characteristics

3. **Generate Inline Documentation** (--type=inline):

   **For each public function, struct, enum, trait**:

   a. **Analyze code semantics**:
   - What does it do? (one-sentence summary)
   - Why does it exist? (purpose in system)
   - How is it used? (from caller analysis)
   - What can go wrong? (error conditions)
   - Any special considerations? (performance, thread-safety)

   b. **Structure documentation**:

   **Rust example**:

   ````rust
   /// Retrieves a person summary projection with caching optimization.
   ///
   /// This function implements the query side of CQRS for person data,
   /// coordinating between a Moka cache (24h TTL) and the EventStore
   /// projection client. It ensures multi-tenancy by filtering events
   /// by `agency_id` in the projection read.
   ///
   /// # Arguments
   ///
   /// * `person_id` - The unique identifier for the person
   /// * `agency_id` - The tenant's agency ID for multi-tenancy filtering
   ///
   /// # Returns
   ///
   /// Returns `Ok(Some((data, cache_hit)))` if the person exists:
   /// - `data`: The person summary projection
   /// - `cache_hit`: `true` if served from cache, `false` if read from EventStore
   ///
   /// Returns `Ok(None)` if:
   /// - Person doesn't exist
   /// - Person exists but belongs to different agency (multi-tenancy)
   ///
   /// # Errors
   ///
   /// Returns `QueryError` if:
   /// - `QueryError::Projection`: EventStore read failure or deserialization error
   /// - `QueryError::Infrastructure`: Connection failure to EventStore
   ///
   /// # Examples
   ///
   /// ```rust
   /// let result = person_service
   ///     .get_person_summary("person-123", "agency-456")
   ///     .await?;
   ///
   /// match result {
   ///     Some((person_data, cache_hit)) => {
   ///         println!("Found person: {:?} (from cache: {})", person_data, cache_hit);
   ///     }
   ///     None => {
   ///         println!("Person not found or access denied");
   ///     }
   /// }
   /// ```
   ///
   /// # Performance
   ///
   /// - Cache hit: ~100μs (in-memory read)
   /// - Cache miss: ~5-50ms (EventStore read + event folding)
   ///
   /// # Thread Safety
   ///
   /// This function is thread-safe. The Moka cache uses lock-free reads
   /// and handles concurrent access efficiently.
   pub async fn get_person_summary(
       &self,
       person_id: &str,
       agency_id: &str,
   ) -> Result<Option<(PersonSummaryData, bool)>, QueryError> {
       // ...
   }
   ````

   **TypeScript/JavaScript example**:

   ````typescript
   /**
    * Retrieves a person summary projection with caching optimization.
    *
    * This function implements the query side of CQRS for person data,
    * coordinating between Redis cache (24h TTL) and the EventStore
    * projection client.
    *
    * @param personId - The unique identifier for the person
    * @param agencyId - The tenant's agency ID for multi-tenancy filtering
    * @returns Promise resolving to person data and cache status, or null if not found
    * @throws {ProjectionError} If EventStore read fails
    * @throws {ConnectionError} If connection to EventStore fails
    *
    * @example
    * ```typescript
    * const result = await personService.getPersonSummary("person-123", "agency-456");
    * if (result) {
    *   const [personData, cacheHit] = result;
    *   console.log(`Found: ${personData.name} (cached: ${cacheHit})`);
    * }
    * ```
    */
   async getPersonSummary(
     personId: string,
     agencyId: string
   ): Promise<[PersonSummaryData, boolean] | null> {
     // ...
   }
   ````

   **Python example**:

   ```python
   def get_person_summary(
       self, person_id: str, agency_id: str
   ) -> Optional[Tuple[PersonSummaryData, bool]]:
       """Retrieve a person summary projection with caching optimization.

       This function implements the query side of CQRS for person data,
       coordinating between Redis cache (24h TTL) and the EventStore
       projection client.

       Args:
           person_id: The unique identifier for the person.
           agency_id: The tenant's agency ID for multi-tenancy filtering.

       Returns:
           A tuple of (person_data, cache_hit) if found, None otherwise.
           The cache_hit boolean indicates if data was served from cache.

       Raises:
           ProjectionError: If EventStore read fails.
           ConnectionError: If connection to EventStore fails.

       Example:
           >>> result = person_service.get_person_summary("person-123", "agency-456")
           >>> if result:
           ...     person_data, cache_hit = result
           ...     print(f"Found: {person_data.name} (cached: {cache_hit})")

       Performance:
           - Cache hit: ~1ms
           - Cache miss: ~10-100ms
       """
       # ...
   ```

   c. **Documentation sections** (include as appropriate):

   **Always include**:
   - Brief summary (1 sentence)
   - Detailed description (1-3 paragraphs)
   - Parameters/Arguments
   - Return value

   **Include when relevant**:
   - Errors/Exceptions
   - Examples (at least 1 for public API)
   - Panics/Safety (Rust)
   - Thread safety (if concurrent access expected)
   - Performance characteristics
   - Security considerations
   - See also (links to related functions)

   d. **Module-level documentation**:

   **Rust** (`//!` at top of file):

   ````rust
   //! Person query service implementation.
   //!
   //! This module implements the domain service layer for person queries,
   //! following the service layer architecture pattern. It coordinates
   //! between the Moka cache and EventStore projection client to provide
   //! optimized read access to person projections.
   //!
   //! # Architecture
   //!
   //! The `PersonQueryService` sits in the domain layer and provides:
   //! - Caching with 24-hour TTL
   //! - Multi-tenancy enforcement via agency_id filtering
   //! - Projection reading from EventStore
   //!
   //! # Usage
   //!
   //! ```rust
   //! let person_service = PersonQueryService::new(projection_client, cache);
   //! let result = person_service.get_person_summary("id", "agency").await?;
   //! ```
   ````

4. **Generate API Documentation** (--type=api):

   **Create structured API reference**:

   a. **Organize by module/namespace**:
   - List all public types, functions, traits
   - Group related items
   - Show signatures with type information

   b. **Generate API reference file** (`docs/api/MODULE_NAME.md`):

   ````markdown
   # PersonQueryService API Reference

   **Module**: `domain::services::person_service`

   ## Overview

   The PersonQueryService provides query-side CQRS operations for person
   projections with caching optimization.

   ## Types

   ### PersonQueryService

   ```rust
   pub struct PersonQueryService {
       projection_client: Arc<dyn ProjectionClient>,
       cache: Arc<Cache<String, PersonSummaryData>>,
   }
   ```
   ````

   The main service for person queries.

   #### Methods

   ##### `new`

   ```rust
   pub fn new(
       projection_client: Arc<dyn ProjectionClient>,
       cache: Arc<Cache<String, PersonSummaryData>>,
   ) -> Self
   ```

   Creates a new PersonQueryService instance.

   **Parameters**:
   - `projection_client`: Implementation of ProjectionClient trait
   - `cache`: Moka cache instance for person data

   **Returns**: New PersonQueryService instance

   ***

   ##### `get_person_summary`

   ```rust
   pub async fn get_person_summary(
       &self,
       person_id: &str,
       agency_id: &str,
   ) -> Result<Option<(PersonSummaryData, bool)>, QueryError>
   ```

   Retrieves a person summary projection with caching.

   **Parameters**:
   - `person_id`: Person identifier
   - `agency_id`: Agency identifier for multi-tenancy

   **Returns**:
   - `Ok(Some((data, cache_hit)))`: Person found
   - `Ok(None)`: Person not found or access denied
   - `Err(QueryError)`: Read failure

   **Performance**: ~100μs (cache hit), ~5-50ms (cache miss)

   **See also**: [`invalidate_cache`](#invalidate_cache)

   ***

   ## Error Types

   ### QueryError

   Errors that can occur during query operations.

   **Variants**:
   - `Projection(String)`: Projection read or deserialization error
   - `Infrastructure(String)`: Connection or infrastructure failure

   ## Examples

   ### Basic Usage

   ```rust
   use domain::services::PersonQueryService;

   let service = PersonQueryService::new(projection_client, cache);

   let result = service
       .get_person_summary("person-123", "agency-456")
       .await?;

   match result {
       Some((data, from_cache)) => {
           println!("Person: {:?}", data.name);
           println!("Cache hit: {}", from_cache);
       }
       None => println!("Not found"),
   }
   ```

   ### Cache Invalidation

   ```rust
   // After updating person data
   service.invalidate_cache("person-123", "agency-456");
   ```

   ```

   ```

5. **Generate README Sections** (--type=readme):

   **Create or update README.md sections**:

   a. **Identify missing README sections**:
   - Installation/Setup
   - Usage/Quickstart
   - API Overview
   - Architecture
   - Configuration
   - Development
   - Testing
   - Contributing

   b. **Generate sections based on code analysis**:

   **Installation** (from Cargo.toml, package.json, etc.):

   ````markdown
   ## Installation

   ### Prerequisites

   - Rust 1.75 or later
   - KurrentDB (EventStore) running on localhost:2113

   ### Build

   ```bash
   cargo build --release
   ```
   ````

   ### Configuration

   Copy the example environment file and configure:

   ```bash
   cp config/.env.example config/.env.dev
   ```

   Edit `config/.env.dev` and set:
   - `JWT_INTERNAL_SECRET`: Your JWT signing secret
   - `EVENTSTORE_CONNECTION_STRING`: KurrentDB connection string

   ````

   **Usage** (from main entry points):
   ```markdown
   ## Usage

   ### Running the Service

   ```bash
   RUNTIME_ENV=dev cargo run
   ````

   The service will start on `http://localhost:8992`.

   ### API Endpoints

   #### Get Person Summary

   ```bash
   curl -H "Authorization: Bearer $JWT_TOKEN" \
        http://localhost:8992/v1/persons/person-123
   ```

   Response:

   ```json
   {
     "person_id": "person-123",
     "name": "John Doe",
     "email": "john@example.com",
     ...
   }
   ```

   ````

   **Architecture** (from CLAUDE.md analysis):
   ```markdown
   ## Architecture

   This service follows a layered architecture:

   ````

   API Layer (handlers, routes)
   ↓
   Domain Layer (services, business logic)
   ↓
   Infrastructure Layer (EventStore, projections)

   ```

   ### Key Components

   - **PersonQueryService**: Domain service for person queries with caching
   - **KurrentProjectionClient**: Reads projections from EventStore
   - **QueryAuditor**: Logs queries to query-journal streams
   - **JWT Middleware**: Multi-tenancy enforcement

   See [CLAUDE.md](../CLAUDE.md) for detailed architecture documentation.
   ```

6. **Generate Architecture Documentation** (--type=architecture):

   **Create comprehensive architecture overview**:

   a. **Analyze codebase structure**:
   - Directory organization
   - Module dependencies
   - Layer boundaries
   - Data flow

   b. **Generate architecture document** (`docs/architecture.md`):

   ```markdown
   # Architecture Overview

   ## System Architecture

   This service implements CQRS (Command Query Responsibility Segregation)
   pattern for reading person and operation projections from EventStore.

   ### Layers

   #### API Layer (`src/api/`)

   HTTP request handling with Axum framework.

   **Components**:

   - `routes/`: Route configuration
   - `handlers/`: Request handlers (persons, operations, health)
   - `docs/`: OpenAPI documentation

   **Responsibilities**:

   - HTTP request/response handling
   - Input validation
   - Authentication extraction
   - Error response formatting (RFC-7807)

   #### Domain Layer (`src/domain/`)

   Business logic and query orchestration.

   **Components**:

   - `services/`: Query services (PersonQueryService, OperationQueryService)
   - `queries/`: Query envelopes and audit logging
   - `models/`: Domain data models

   **Responsibilities**:

   - Query execution logic
   - Caching coordination
   - Business rule enforcement
   - Query audit logging

   #### Infrastructure Layer (`src/infra/`)

   External system adapters.

   **Components**:

   - `projections/`: Projection read clients (Kurrent, MongoDB)
   - `eventstore/`: EventStore write client

   **Responsibilities**:

   - EventStore communication
   - Projection reading and folding
   - Connection management

   ### Data Flow
   ```

   HTTP Request
   ↓
   [JWT Middleware] → Extract agency_id, actor_id
   ↓
   [Handler] → Parse request
   ↓
   [PersonQueryService]
   ↓
   Check cache → [Moka Cache]
   ↓ (miss)
   [KurrentProjectionClient] → Read events from EventStore
   ↓
   Fold events → PersonSummaryData
   ↓
   Update cache
   ↓
   [QueryAuditor] → Log query to query-journal stream
   ↓
   [Handler] → Return JSON response

   ```

   ## Key Design Decisions

   ### Caching Strategy

   **Decision**: Use Moka for in-memory caching with 24h TTL

   **Rationale**:
   - Person data changes infrequently
   - High read-to-write ratio
   - Reduces EventStore load
   - Improves response time (100μs vs 5-50ms)

   ### Multi-Tenancy

   **Decision**: Enforce at projection client level via event metadata filtering

   **Rationale**:
   - Defense in depth (beyond JWT validation)
   - Prevents data leakage even if auth bypassed
   - EventStore events tagged with agency_id

   ### Service Layer Pattern

   **Decision**: Separate domain services from handlers and infrastructure

   **Rationale**:
   - Business logic independent of HTTP framework
   - Easier to test (mock infrastructure)
   - Enables future transport layers (gRPC, etc.)
   - Clear separation of concerns
   ```

7. **Apply Generated Documentation**:

   a. **Preview mode** (if --preview):
   - Show all generated docs
   - Don't write to files
   - Let user review before applying

   b. **Write inline documentation**:
   - Edit source files to add/update doc comments
   - Preserve existing docs if --append mode
   - Replace existing docs if --overwrite mode

   c. **Write external documentation**:
   - Create/update `docs/api/` files
   - Update README.md sections
   - Create `docs/architecture.md`

   d. **Create commit**:
   - Commit inline docs separately from external docs
   - Use conventional commit format:
     - `docs: add inline documentation for PersonQueryService`
     - `docs: add API reference documentation`
     - `docs(readme): add usage and architecture sections`

8. **Generate Summary Report**:

   ```markdown
   # Documentation Generated

   ## Inline Documentation

   ✅ **src/domain/services/person_service.rs**

   - Added docs for PersonQueryService struct
   - Added docs for 3 public methods
   - Added module-level documentation

   ✅ **src/domain/services/operation_service.rs**

   - Added docs for OperationQueryService struct
   - Added docs for 2 public methods

   ## API Documentation

   ✅ **docs/api/person_service.md**

   - Full API reference for PersonQueryService
   - Includes examples and error documentation

   ## README Updates

   ✅ **README.md**

   - Added Installation section
   - Added Usage section with API examples
   - Added Architecture overview

   ## Commits Created

   - abc123f docs: add inline documentation for query services
   - def456g docs: add API reference documentation
   - ghi789h docs(readme): add usage and architecture sections

   ## Next Steps

   1. Review generated documentation
   2. Add any missing examples or details
   3. Run doc tests (if applicable):
      - Rust: `cargo test --doc`
      - TypeScript: `npm run docs`
   ```

9. **Validation**:

   **Before writing documentation**:
   - [ ] Code analysis complete and accurate
   - [ ] Documentation style matches project conventions
   - [ ] Examples are correct and runnable
   - [ ] Error conditions documented
   - [ ] Performance characteristics noted (if relevant)
   - [ ] Language-specific format is correct

   **After writing documentation**:
   - [ ] Doc comments compile without errors (Rust: cargo doc)
   - [ ] Examples are syntactically correct
   - [ ] Links to other items are valid
   - [ ] No typos or grammar errors
   - [ ] Commits created with good messages

## Examples

### Example 1: Generate inline docs for a file

**Command**: `/docgen src/domain/services/person_service.rs`

**Output**:

```
Analyzing src/domain/services/person_service.rs...

Found 1 struct, 4 public methods, 0 module docs

Generating documentation...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Generated Documentation Preview:

//! Person query service implementation.
//!
//! This module implements the domain service layer for person queries,
//! following the service layer architecture pattern.

/// Coordinates person projection queries with caching optimization.
///
/// This service implements the query side of CQRS for person data...
pub struct PersonQueryService { ... }

/// Retrieves a person summary projection with caching optimization.
///
/// # Arguments
/// * `person_id` - The unique identifier for the person
/// ...
pub async fn get_person_summary(...) -> Result<...> { ... }

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Apply these changes? [Y/n]: y

Writing documentation to file...
✅ Updated src/domain/services/person_service.rs

Running cargo doc to verify...
✅ Documentation compiles successfully

✅ Committed: abc123f docs: add inline documentation for PersonQueryService

Next steps:
  - View docs: cargo doc --open
  - Review at: target/doc/leads_queries/domain/services/person_service/index.html
```

### Example 2: Generate API reference

**Command**: `/docgen src/domain/services --type=api`

**Output**:

```
Analyzing src/domain/services/...

Found:
- PersonQueryService (4 public methods)
- OperationQueryService (2 public methods)

Generating API reference documentation...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Created: docs/api/query_services.md

# Query Services API Reference

## PersonQueryService
...

## OperationQueryService
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Created docs/api/query_services.md

✅ Committed: def456g docs: add API reference for query services
```

### Example 3: Update README

**Command**: `/docgen --type=readme`

**Output**:

```
Analyzing project structure...

Current README sections:
✓ Project Overview
✗ Installation (missing)
✗ Usage (missing)
✗ Architecture (missing)
✓ License

Generating missing sections...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Will add to README.md:

## Installation
[Generated installation instructions]

## Usage
[Generated usage examples]

## Architecture
[Generated architecture overview]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Add these sections to README.md? [Y/n]: y

✅ Updated README.md (added 3 sections)

✅ Committed: ghi789h docs(readme): add installation, usage, and architecture sections
```

## Context

Additional user context: $ARGUMENTS
