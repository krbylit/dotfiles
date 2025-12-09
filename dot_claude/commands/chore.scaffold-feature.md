---
description: Scaffold a new feature following project patterns and architecture conventions
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "<feature-name> [--type=api|service|handler|model|full] [--preview]"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command scaffolds a new feature by analyzing existing project patterns and generating boilerplate code that follows project conventions. It creates all necessary files (handlers, services, models, tests) with proper structure, dependencies, and documentation.

### Execution Steps

1. **Parse Arguments and Understand Feature**:

   **Feature name** (required):
   - `/scaffold-feature company` - Entity name
   - `/scaffold-feature "Company Query API"` - Feature description

   **Type flags** (what to generate):
   - `--type=full` (complete feature: handler + service + model + tests, default)
   - `--type=api` (handler + routes only)
   - `--type=service` (domain service only)
   - `--type=handler` (API handler only)
   - `--type=model` (domain model only)

   **Action flags**:
   - `--preview` (show generated code without writing files)
   - `--interactive` (ask before creating each file)
   - `--dry-run` (show file list without generating code)

   **Extract feature information**:
   - Feature name (e.g., "Company")
   - Entity type (singular: Company, plural: Companies)
   - Feature scope (API endpoint, service, full stack)

2. **Analyze Project Patterns**:

   **Critical: Generate code that matches existing patterns**

   a. **Read project architecture** (`CLAUDE.md`):
   - Architecture pattern (service layer, CQRS, etc.)
   - Layer structure (API, Domain, Infrastructure)
   - Naming conventions
   - Code organization

   b. **Identify similar existing features**:
   - Find comparable feature (e.g., for "Company", study "Person")
   - Analyze structure and patterns
   - Note file organization, naming, imports

   c. **Analyze existing code samples**:

   **API handlers**:
   - Read existing handler (e.g., `api/handlers/persons.rs`)
   - Note structure: imports, handler function signature, error handling
   - Identify patterns: State extraction, path parameters, response types

   **Domain services**:
   - Read existing service (e.g., `domain/services/person_service.rs`)
   - Note: struct fields, constructor, method signatures
   - Identify patterns: dependency injection, caching, error handling

   **Models**:
   - Read existing model (e.g., `domain/models/person_summary.rs`)
   - Note: struct definition, derives, serialization

   **Routes**:
   - Read route configuration (e.g., `api/routes/v1.rs`)
   - Note: route registration pattern, method chaining

   **Tests**:
   - Read existing tests (e.g., `tests/person_service.rs`)
   - Note: test structure, mocking patterns, assertions

   d. **Extract patterns**:
   - Imports: What modules are commonly imported?
   - Error handling: How are errors propagated?
   - Async patterns: `async fn`, `.await?`
   - Dependency injection: How are deps passed?
   - Logging: What's logged and how?
   - Documentation: Doc comment style

3. **Design Feature Structure**:

   **For full feature** (--type=full):

   ```
   Files to create:
   ├── src/domain/models/company.rs           (CompanyData model)
   ├── src/domain/services/company_service.rs (CompanyQueryService)
   ├── src/api/handlers/companies.rs          (get_company handler)
   ├── tests/company_service.rs                (unit tests)
   └── tests/integration/company_api.rs        (integration tests)

   Files to modify:
   ├── src/domain/models/mod.rs               (add pub mod company)
   ├── src/domain/services/mod.rs             (add pub mod company_service)
   ├── src/api/handlers/mod.rs                (add pub mod companies)
   ├── src/api/routes/v1.rs                   (add company routes)
   ├── src/app.rs                              (add CompanyQueryService to AppState)
   └── src/main.rs or lib.rs                   (wire up dependencies)
   ```

   **Component breakdown**:

   a. **Model** (`domain/models/company.rs`):
   - `CompanyData` struct
   - Serialization derives
   - Field definitions based on domain

   b. **Service** (`domain/services/company_service.rs`):
   - `CompanyQueryService` struct
   - Dependencies (projection client, cache)
   - `get_company()` method
   - `invalidate_cache()` method
   - Doc comments

   c. **Handler** (`api/handlers/companies.rs`):
   - `get_company()` async handler
   - Path parameter extraction
   - Service call
   - Query audit logging
   - Error handling
   - Doc comments

   d. **Routes** (modify `api/routes/v1.rs`):
   - Add `GET /v1/companies/{id}`
   - Wire to handler

   e. **AppState** (modify `app.rs`):
   - Add `company_service: Arc<CompanyQueryService>`
   - Initialize in `new()`

   f. **Tests**:
   - Unit tests for service (cache behavior)
   - Integration tests for API endpoint

4. **Generate Code**:

   **For each file to be created**:

   a. **Generate from template**:
   - Use similar existing file as template
   - Replace entity names (Person → Company, person → company)
   - Adapt to specific requirements

   b. **Customize for feature**:
   - Adjust field names based on domain
   - Update documentation
   - Modify logic if needed

   c. **Ensure correctness**:
   - Proper imports
   - Correct types
   - Matching patterns from existing code
   - No syntax errors

   ### Example: Model Generation

   **Template** (from `person_summary.rs`):

   ```rust
   use serde::{Deserialize, Serialize};

   /// PersonSummaryData projection.
   #[derive(Debug, Clone, Serialize, Deserialize)]
   pub struct PersonSummaryData {
       pub person_id: String,
       pub name: String,
       pub email: String,
       pub agency_id: String,
       pub created_at: String,
   }
   ```

   **Generated** (`company.rs`):

   ```rust
   use serde::{Deserialize, Serialize};

   /// CompanyData projection.
   #[derive(Debug, Clone, Serialize, Deserialize)]
   pub struct CompanyData {
       pub company_id: String,
       pub name: String,
       pub industry: String,
       pub agency_id: String,
       pub created_at: String,
   }
   ```

   ### Example: Service Generation

   **Template** (from `person_service.rs`):

   ```rust
   use std::sync::Arc;
   use moka::future::Cache;
   use crate::domain::models::person_summary::PersonSummaryData;
   use crate::domain::errors::QueryError;
   use crate::infra::projections::client::ProjectionClient;

   /// Service for querying person projections with caching.
   pub struct PersonQueryService {
       projection_client: Arc<dyn ProjectionClient>,
       cache: Arc<Cache<String, PersonSummaryData>>,
   }

   impl PersonQueryService {
       /// Create a new PersonQueryService.
       pub fn new(
           projection_client: Arc<dyn ProjectionClient>,
           cache: Arc<Cache<String, PersonSummaryData>>,
       ) -> Self {
           Self {
               projection_client,
               cache,
           }
       }

       /// Get person summary by ID with caching.
       pub async fn get_person_summary(
           &self,
           person_id: &str,
           agency_id: &str,
       ) -> Result<Option<(PersonSummaryData, bool)>, QueryError> {
           // Check cache
           let cache_key = format!("person:{}:{}", agency_id, person_id);

           if let Some(cached) = self.cache.get(&cache_key).await {
               return Ok(Some((cached, true)));
           }

           // Cache miss - read from projection
           let projection = self.projection_client
               .read_projection("person", person_id, agency_id)
               .await?;

           if let Some(data) = projection {
               self.cache.insert(cache_key, data.clone()).await;
               Ok(Some((data, false)))
           } else {
               Ok(None)
           }
       }

       /// Invalidate cached person data.
       pub fn invalidate_cache(&self, person_id: &str, agency_id: &str) {
           let cache_key = format!("person:{}:{}", agency_id, person_id);
           self.cache.invalidate(&cache_key);
       }
   }
   ```

   **Generated** (`company_service.rs`):

   ```rust
   use std::sync::Arc;
   use moka::future::Cache;
   use crate::domain::models::company::CompanyData;
   use crate::domain::errors::QueryError;
   use crate::infra::projections::client::ProjectionClient;

   /// Service for querying company projections with caching.
   pub struct CompanyQueryService {
       projection_client: Arc<dyn ProjectionClient>,
       cache: Arc<Cache<String, CompanyData>>,
   }

   impl CompanyQueryService {
       /// Create a new CompanyQueryService.
       pub fn new(
           projection_client: Arc<dyn ProjectionClient>,
           cache: Arc<Cache<String, CompanyData>>,
       ) -> Self {
           Self {
               projection_client,
               cache,
           }
       }

       /// Get company by ID with caching.
       pub async fn get_company(
           &self,
           company_id: &str,
           agency_id: &str,
       ) -> Result<Option<(CompanyData, bool)>, QueryError> {
           // Check cache
           let cache_key = format!("company:{}:{}", agency_id, company_id);

           if let Some(cached) = self.cache.get(&cache_key).await {
               return Ok(Some((cached, true)));
           }

           // Cache miss - read from projection
           let projection = self.projection_client
               .read_projection("company", company_id, agency_id)
               .await?;

           if let Some(data) = projection {
               self.cache.insert(cache_key, data.clone()).await;
               Ok(Some((data, false)))
           } else {
               Ok(None)
           }
       }

       /// Invalidate cached company data.
       pub fn invalidate_cache(&self, company_id: &str, agency_id: &str) {
           let cache_key = format!("company:{}:{}", agency_id, company_id);
           self.cache.invalidate(&cache_key);
       }
   }
   ```

   ### Example: Handler Generation

   **Generated** (`api/handlers/companies.rs`):

   ```rust
   use axum::{
       extract::{Path, State},
       Extension, Json,
   };
   use std::sync::Arc;

   use crate::app::AppState;
   use crate::domain::models::company::CompanyData;
   use crate::http::errors::AppError;
   use crate::middleware::auth::AuthContext;

   /// Get company by ID.
   ///
   /// # Endpoint
   /// `GET /v1/companies/{id}`
   ///
   /// # Authentication
   /// Requires valid JWT with `agency_id` claim.
   ///
   /// # Responses
   /// - `200 OK`: Company found, returns CompanyData
   /// - `404 Not Found`: Company doesn't exist or belongs to different agency
   /// - `500 Internal Server Error`: Query execution failed
   pub async fn get_company(
       State(state): State<Arc<AppState>>,
       Path(company_id): Path<String>,
       Extension(auth): Extension<AuthContext>,
   ) -> Result<Json<CompanyData>, AppError> {
       // Query company service
       let result = state
           .company_service
           .get_company(&company_id, &auth.agency_id)
           .await?;

       match result {
           Some((company_data, cache_hit)) => {
               // Log query for audit trail
               state
                   .query_auditor
                   .log_company_query(&company_id, &auth.agency_id, cache_hit)
                   .await?;

               Ok(Json(company_data))
           }
           None => Err(AppError::NotFound),
       }
   }
   ```

5. **Update Module Exports**:

   **Add to `domain/models/mod.rs`**:

   ```rust
   pub mod company;
   ```

   **Add to `domain/services/mod.rs`**:

   ```rust
   pub mod company_service;
   ```

   **Add to `api/handlers/mod.rs`**:

   ```rust
   pub mod companies;
   ```

6. **Update Routes**:

   **Modify `api/routes/v1.rs`**:

   ```rust
   use crate::api::handlers::companies;

   pub fn routes(state: Arc<AppState>) -> Router {
       Router::new()
           .route("/persons/:id", get(handlers::persons::get_person))
           .route("/operations/:id", get(handlers::operations::get_operation))
           .route("/companies/:id", get(companies::get_company))  // ← ADD THIS
           .route("/health", get(handlers::health::health_check))
           .with_state(state)
   }
   ```

7. **Update AppState**:

   **Modify `src/app.rs`**:

   ```rust
   use crate::domain::services::company_service::CompanyQueryService;

   pub struct AppState {
       pub settings: ArcSwap<Settings>,
       pub clock: Arc<dyn Clock>,
       pub person_service: Arc<PersonQueryService>,
       pub operation_service: Arc<OperationQueryService>,
       pub company_service: Arc<CompanyQueryService>,  // ← ADD THIS
       pub query_auditor: Arc<QueryAuditor>,
   }

   impl AppState {
       pub fn new(
           settings: Settings,
           clock: Arc<dyn Clock>,
           person_service: Arc<PersonQueryService>,
           operation_service: Arc<OperationQueryService>,
           company_service: Arc<CompanyQueryService>,  // ← ADD THIS
           query_auditor: Arc<QueryAuditor>,
       ) -> Self {
           Self {
               settings: ArcSwap::new(Arc::new(settings)),
               clock,
               person_service,
               operation_service,
               company_service,  // ← ADD THIS
               query_auditor,
           }
       }
   }
   ```

8. **Generate Tests**:

   **Unit tests** (`tests/company_service.rs`):

   ```rust
   use std::sync::Arc;
   use moka::future::Cache;
   use crate::domain::services::company_service::CompanyQueryService;
   use crate::domain::models::company::CompanyData;
   use crate::infra::projections::client::ProjectionClient;

   // Mock implementation
   struct MockProjectionClient {
       response: Option<serde_json::Value>,
   }

   #[async_trait]
   impl ProjectionClient for MockProjectionClient {
       async fn read_projection(
           &self,
           _projection_type: &str,
           _id: &str,
           _agency_id: &str,
       ) -> Result<Option<serde_json::Value>, ProjectionClientError> {
           Ok(self.response.clone())
       }
   }

   #[tokio::test]
   async fn test_get_company_cache_hit() {
       let cache = Arc::new(Cache::new(100));
       let client = Arc::new(MockProjectionClient { response: None });
       let service = CompanyQueryService::new(client, cache.clone());

       // Pre-populate cache
       let company_data = CompanyData {
           company_id: "comp-1".to_string(),
           name: "Acme Corp".to_string(),
           industry: "Tech".to_string(),
           agency_id: "agency-1".to_string(),
           created_at: "2025-01-01T00:00:00Z".to_string(),
       };

       cache.insert("company:agency-1:comp-1".to_string(), company_data.clone()).await;

       // Query should hit cache
       let result = service.get_company("comp-1", "agency-1").await.unwrap();

       assert!(result.is_some());
       let (data, cache_hit) = result.unwrap();
       assert_eq!(data.company_id, "comp-1");
       assert!(cache_hit);
   }

   #[tokio::test]
   async fn test_get_company_cache_miss() {
       // Test cache miss scenario
       // ...
   }
   ```

9. **Preview and Confirm**:

   **Generate preview report**:

   ````markdown
   # Feature Scaffold Preview: Company

   ## Files to Create (6)

   ✅ src/domain/models/company.rs (45 lines)
   ✅ src/domain/services/company_service.rs (78 lines)
   ✅ src/api/handlers/companies.rs (52 lines)
   ✅ tests/company_service.rs (120 lines)
   ✅ tests/integration/company_api.rs (85 lines)

   ## Files to Modify (5)

   ✅ src/domain/models/mod.rs (+1 line)
   ✅ src/domain/services/mod.rs (+1 line)
   ✅ src/api/handlers/mod.rs (+1 line)
   ✅ src/api/routes/v1.rs (+2 lines)
   ✅ src/app.rs (+15 lines)

   ## New API Endpoint

   **GET /v1/companies/{id}**

   - Handler: `api::handlers::companies::get_company`
   - Service: `CompanyQueryService::get_company`
   - Model: `CompanyData`
   - Cache: 24h TTL (Moka)

   ## Generated Components

   ### Model: CompanyData

   ```rust
   pub struct CompanyData {
       pub company_id: String,
       pub name: String,
       pub industry: String,
       pub agency_id: String,
       pub created_at: String,
   }
   ```
   ````

   ### Service: CompanyQueryService
   - `get_company(company_id, agency_id)` - Query with caching
   - `invalidate_cache(company_id, agency_id)` - Manual invalidation

   ### Handler: get_company
   - Extracts company_id from path
   - Uses AuthContext for multi-tenancy
   - Logs query via QueryAuditor
   - Returns JSON or 404

   ## Next Steps After Scaffolding
   1. **Customize model fields**:
      - Edit `CompanyData` struct to match domain requirements
      - Add/remove fields as needed

   2. **Run tests**:

      ```bash
      cargo test company
      ```

   3. **Build and verify**:

      ```bash
      cargo build
      cargo clippy
      ```

   4. **Test API endpoint**:

      ```bash
      curl -H "Authorization: Bearer $JWT" \
           http://localhost:8992/v1/companies/comp-123
      ```

   5. **Update documentation**:
      - Add company endpoint to API docs
      - Update CLAUDE.md if architecture changed

   ***

   Apply scaffold? [Y/n]:

   ```

   ```

10. **Create Files and Commit**:

    a. **If --preview mode**:
    - Show preview report
    - Exit without writing

    b. **If --interactive mode**:
    - Ask before each file
    - Show diff for modifications

    c. **Otherwise**:
    - Create all files
    - Apply modifications
    - Verify compilation

    d. **Create atomic commits**:
    - Commit 1: `feat(company): add CompanyData model`
    - Commit 2: `feat(company): add CompanyQueryService`
    - Commit 3: `feat(company): add GET /v1/companies/{id} endpoint`
    - Commit 4: `test(company): add unit and integration tests`

11. **Validation**:

    **Before writing files**:
    - [ ] All patterns extracted from existing code
    - [ ] Naming consistent with project conventions
    - [ ] Imports are correct
    - [ ] Types match existing patterns
    - [ ] Documentation follows project style

    **After scaffolding**:
    - [ ] Code compiles without errors
    - [ ] No clippy warnings
    - [ ] Tests run successfully
    - [ ] Module exports updated
    - [ ] Routes registered
    - [ ] AppState wired correctly

## Edge Cases & Error Handling

**No similar feature exists**:

- Use generic template
- Note in output: "No similar feature found, using generic template"
- Recommend review for project-specific patterns

**Conflicting files**:

- If file already exists, ask user:
  - Overwrite, Skip, Rename
- Default: Skip (don't overwrite without permission)

**Compilation errors after scaffold**:

- Run `cargo build` or equivalent
- If errors, show them to user
- Offer to fix common issues (missing imports, etc.)

**Test failures**:

- Expected (tests need implementation)
- Note which tests are placeholder-only

## Examples

### Example 1: Full feature scaffold

**Command**: `/scaffold-feature company`

**Output**: (Shows preview report as in step 9, creates all files, commits)

### Example 2: Preview mode

**Command**: `/scaffold-feature company --preview`

**Output**: Shows preview without writing files

### Example 3: API-only scaffold

**Command**: `/scaffold-feature company --type=api`

**Output**:

```
Scaffolding API handler for Company...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files to create:
✅ src/api/handlers/companies.rs

Files to modify:
✅ src/api/handlers/mod.rs
✅ src/api/routes/v1.rs

Endpoint: GET /v1/companies/{id}

Note: You'll need to:
- Create CompanyData model
- Create CompanyQueryService
- Wire service in AppState

Apply scaffold? [Y/n]: y

✅ Created src/api/handlers/companies.rs
✅ Updated src/api/handlers/mod.rs
✅ Updated src/api/routes/v1.rs

✅ Committed: feat(company): add GET /v1/companies/{id} API endpoint
```

## Context

Additional user context: $ARGUMENTS
