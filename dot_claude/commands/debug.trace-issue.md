---
description: Trace and debug issues by analyzing code paths, data flow, and execution context
allowed-tools: Read, Grep, Glob, Bash, Task
argument-hint: "[issue-description or error-message] [--scope=full|module|file] [--depth=quick|thorough]"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command helps trace and debug issues by analyzing code execution paths, data flow, error propagation, and identifying root causes. It combines static code analysis with dynamic reasoning to provide actionable debugging insights.

### Execution Steps

1. **Parse Arguments and Understand Issue**:

   **Input formats**:
   - Error message: `/trace-issue "Person not found for valid ID"`
   - Stack trace: `/trace-issue <paste stack trace>`
   - Symptom description: `/trace-issue "Cache returns stale data"`
   - Bug report: `/trace-issue "GET /persons/{id} returns 500"`
   - Log snippet: `/trace-issue <paste error logs>`

   **Flags**:
   - `--scope=full` (trace across entire codebase, default)
   - `--scope=module <path>` (limit to specific module)
   - `--scope=file <path>` (limit to specific file)
   - `--depth=quick` (surface-level analysis, 2-3 likely causes)
   - `--depth=thorough` (deep analysis, all possible causes, default)

   **Extract key information**:
   - Error type/message
   - Stack trace (if provided)
   - Symptoms (what's wrong)
   - Expected vs actual behavior
   - Context (when does it happen, frequency)

2. **Locate Entry Points**:

   **Strategy**: Find where the issue manifests

   a. **If error message provided**:
   - Search for error message text in codebase
   - `grep -r "Person not found" src/`
   - Identify where error is created/thrown
   - Note file path and line number

   b. **If stack trace provided**:
   - Parse stack trace for file paths and line numbers
   - Extract function call chain
   - Identify deepest frame in user code (not library)
   - Start tracing from that point

   c. **If symptom description**:
   - Identify relevant modules/components
   - For "Cache returns stale data": find cache-related code
   - For "API returns 500": find API handler
   - Search for keywords in symptom description

   d. **If HTTP endpoint issue**:
   - Locate route definition (e.g., `GET /v1/persons/{id}`)
   - Find handler function
   - This is the entry point for tracing

3. **Build Execution Path**:

   **Strategy**: Trace code flow from entry to error

   a. **Create call graph**:
   - Start from entry point (handler, main function, etc.)
   - Follow function calls
   - Build tree of execution path

   Example:

   ```
   get_person (handler)
       ↓
   PersonQueryService::get_person_summary
       ↓
   Check cache
       ↓ (cache miss)
   KurrentProjectionClient::read_projection
       ↓
   EventStore::read_stream
       ↓
   [ERROR: Stream not found]
   ```

   b. **For each step in path**:
   - Read function implementation
   - Note parameters passed
   - Identify conditional branches
   - Note error handling
   - Trace data transformations

   c. **Identify decision points**:
   - Where could flow diverge?
   - What conditions affect behavior?
   - Are there early returns?
   - What validations are performed?

4. **Analyze Data Flow**:

   **Strategy**: Track how data changes through execution

   a. **Identify data sources**:
   - Where does input data come from?
   - HTTP request? Database? Cache? Config?
   - What's the initial state?

   b. **Trace data transformations**:
   - How is data modified at each step?
   - Type conversions, parsing, serialization
   - Filtering, mapping, validation
   - Accumulation, aggregation

   c. **Identify data dependencies**:
   - What data does each function need?
   - Where does it come from?
   - Could data be missing/invalid?
   - Could data be stale?

   d. **Look for data flow issues**:
   - **Missing data**: Is required data available?
   - **Invalid data**: Could data fail validation?
   - **Type mismatches**: Are conversions correct?
   - **Stale data**: Is cached data outdated?
   - **Race conditions**: Could data change mid-execution?

5. **Analyze Error Propagation**:

   **Strategy**: Understand how errors bubble up

   a. **Identify error types**:
   - What errors can occur at each step?
   - What error types are returned?
   - Are errors transformed as they propagate?

   b. **Trace error handling**:
   - Where are errors caught?
   - How are they handled (logged, transformed, returned)?
   - Are errors properly propagated?
   - Could errors be swallowed?

   c. **Check error context**:
   - Is enough context preserved in errors?
   - Can you tell where error originated?
   - Are error messages actionable?

   d. **Look for error handling issues**:
   - **Swallowed errors**: Caught but not logged/returned
   - **Lost context**: Error message doesn't say where it happened
   - **Wrong error type**: Error converted incorrectly
   - **Missing error handling**: No `?` or `try/catch`

6. **Identify Root Cause Hypotheses**:

   **Generate ranked list of likely causes**:

   a. **Analyze execution path for issues**:

   **Common patterns**:
   1. **Missing validation**:
      - Input not validated before use
      - Assumes data is valid
      - Example: Using `person_id` without checking if empty

   2. **Incorrect assumptions**:
      - Code assumes something that might not be true
      - Example: Assumes cache always has data
      - Example: Assumes agency_id is always present in JWT

   3. **Race conditions**:
      - Concurrent access to shared state
      - Cache invalidation timing issues
      - Non-atomic operations

   4. **State inconsistency**:
      - State updated in one place but not another
      - Cache and DB out of sync
      - Event stream corruption

   5. **Configuration issues**:
      - Wrong environment variable
      - Missing configuration value
      - Incorrect connection string

   6. **Edge case handling**:
      - Code doesn't handle empty collections
      - Off-by-one errors
      - Null/None handling

   7. **Integration issues**:
      - External service not responding
      - API contract mismatch
      - Network timeouts

   8. **Logic errors**:
      - Incorrect conditional logic
      - Wrong operator (e.g., `&&` vs `||`)
      - Inverted logic (`!`)

   b. **Rank hypotheses**:
   - **High probability**: Direct evidence in code
   - **Medium probability**: Plausible based on symptoms
   - **Low probability**: Possible but less likely

   c. **For each hypothesis**:
   - Explain why this could cause the symptom
   - Show where in code the issue would be
   - Explain how to verify this hypothesis
   - Suggest potential fix

7. **Generate Investigation Plan**:

   **Provide actionable debugging steps**:

   a. **Immediate checks** (quick verification):
   - Add logging at key points
   - Check configuration values
   - Verify input data
   - Check error logs

   b. **Hypothesis testing** (for each root cause):
   - How to reproduce the issue
   - What to observe
   - What evidence confirms/refutes hypothesis

   c. **Instrumentation recommendations**:
   - Where to add logging
   - What metrics to track
   - What tests to write

8. **Generate Trace Report**:

   ```markdown
   # Issue Trace Report

   **Issue**: [Description from user input]
   **Generated**: [Timestamp]
   **Scope**: [full/module/file]

   ## Summary

   **Entry Point**: `[file:line]` - [function name]
   **Error Location**: `[file:line]` - [where error occurs/thrown]
   **Execution Path Length**: [N steps]
   **Root Cause Hypotheses**: [N identified]

   ---

   ## Execution Path
   ```

   1. api/handlers/persons.rs:42 - get_person()
      ↓ calls PersonQueryService::get_person_summary(person_id, agency_id)

   2. domain/services/person_service.rs:78 - get_person_summary()
      ↓ checks cache with key "person:{agency_id}:{person_id}"
      ↓ cache.get(cache_key)
      ↓ CACHE MISS

   3. domain/services/person_service.rs:89 - get_person_summary()
      ↓ calls projection_client.read_projection("person", person_id, agency_id)

   4. infra/projections/kurrent_client.rs:67 - read_projection()
      ↓ reads stream "person-{person_id}"
      ↓ filters events by metadata.agency_id == agency_id
      ↓ folds events into PersonSummaryData

   5. infra/projections/kurrent_client.rs:112 - read_projection()
      ↓ returns Ok(None) if no events after filtering
      ↑ bubbles up to handler

   6. api/handlers/persons.rs:48 - get_person()
      ↓ matches on None
      ↓ returns 404 Not Found

   ````

   ---

   ## Data Flow

   **Input Data**:
   - `person_id`: From URL path parameter
   - `agency_id`: From JWT claims (middleware)

   **Data Transformations**:
   1. `person_id` extracted from path: `/v1/persons/{person_id}`
   2. `agency_id` extracted from JWT by auth middleware
   3. Cache key constructed: `person:{agency_id}:{person_id}`
   4. EventStore stream name: `person-{person_id}`
   5. Events filtered by: `metadata.agency_id == agency_id`
   6. Events folded into: `PersonSummaryData` JSON

   **Data Dependencies**:
   - Requires: Valid JWT with `agency_id` claim
   - Requires: EventStore stream exists
   - Requires: Events have `agency_id` in metadata
   - Optional: Cached data (improves performance)

   ---

   ## Root Cause Hypotheses

   ### 🔴 High Probability

   #### Hypothesis 1: Cross-Agency Query (Multi-Tenancy Filtering)

   **What**: Person exists in EventStore but belongs to different agency

   **Why this causes the symptom**:
   - Person stream "person-123" exists in EventStore
   - BUT events have metadata.agency_id = "agency-A"
   - User JWT has agency_id = "agency-B"
   - KurrentClient filters events: `metadata.agency_id == "agency-B"`
   - No events match filter → `Ok(None)` returned
   - Handler returns 404 (which is correct for multi-tenancy)

   **Evidence**:
   - Location: `infra/projections/kurrent_client.rs:112`
   - Code filters by agency_id in event metadata

   **How to verify**:
   1. Log the agency_id from JWT
   2. Log the agency_id from event metadata
   3. Check if they match
   4. If they don't match, this is the cause

   **If confirmed, this is correct behavior** (multi-tenancy working as designed).
   User should not see other agencies' data.

   ---

   #### Hypothesis 2: Person Stream Doesn't Exist

   **What**: EventStore stream "person-{id}" doesn't exist

   **Why this causes the symptom**:
   - Handler calls `read_projection("person", person_id, agency_id)`
   - KurrentClient tries to read stream `person-{person_id}`
   - Stream doesn't exist in EventStore
   - Returns `Ok(None)`
   - Handler returns 404

   **Evidence**:
   - EventStore would return StreamNotFound error
   - But code might treat this as Ok(None) instead of error

   **Location**: `infra/projections/kurrent_client.rs:67`

   **How to verify**:
   1. Check EventStore for stream existence:
      ```bash
      curl http://localhost:2113/streams/person-{id}
   ````

   1. Add logging before reading stream:

      ```rust
      tracing::debug!("Reading stream person-{}", person_id);
      ```

   2. Check if person was ever created (no PersonCreated event)

   **Potential fix**:
   - If person should exist: Create the person first
   - If code issue: Verify stream reading logic handles missing streams correctly

   ***

   ### 🟡 Medium Probability

   #### Hypothesis 3: Cache Key Mismatch

   **What**: Cache key construction doesn't match lookup

   **Why this causes the symptom**:
   - Cache key built as `person:{agency_id}:{person_id}`
   - But one component might use different format
   - Cache always misses
   - Queries always hit EventStore (slower)
   - If EventStore has issues, errors propagate

   **Evidence**: Would need to inspect cache key construction in both places

   **Locations**:
   - Cache set: `domain/services/person_service.rs:95`
   - Cache get: `domain/services/person_service.rs:82`

   **How to verify**:
   1. Add logging for cache key:

      ```rust
      let cache_key = format!("person:{}:{}", agency_id, person_id);
      tracing::debug!("Cache key: {}", cache_key);
      ```

   2. Check if format matches in both places
   3. Monitor cache hit rate

   **Potential fix**:
   - Extract cache key construction to helper function
   - Ensure consistent formatting

   ***

   #### Hypothesis 4: Event Folding Error

   **What**: Events exist but can't be folded into PersonSummaryData

   **Why this causes the symptom**:
   - Stream exists, events exist
   - But deserialization fails during event folding
   - Error during fold might be treated as empty result
   - Returns None instead of Error

   **Evidence**: Check error handling in fold logic

   **Location**: `infra/projections/kurrent_client.rs:112-145`

   **How to verify**:
   1. Add error logging in fold logic
   2. Check for deserialization errors
   3. Verify event schema matches expected format

   **Potential fix**:
   - Return proper error instead of None on fold failure
   - Fix event schema if mismatched
   - Add better error handling

   ***

   ### 🟢 Low Probability

   #### Hypothesis 5: JWT Missing agency_id

   **What**: JWT doesn't contain agency_id claim

   **Why this causes the symptom**:
   - Auth middleware tries to extract agency_id from JWT
   - Claim is missing or null
   - agency_id becomes empty string or default value
   - Query filters by wrong agency_id
   - Returns no results

   **Evidence**: Check auth middleware JWT parsing

   **Location**: `middleware/auth.rs:45-67`

   **How to verify**:
   1. Log JWT claims after parsing
   2. Check if agency_id is present
   3. Decode JWT manually to inspect claims

   **Potential fix**:
   - Return 401 if agency_id missing (don't use default)
   - Validate JWT claims in middleware

   ***

   ## Investigation Plan

   ### Immediate Checks (5 minutes)
   1. **Check logs** for this request:

      ```bash
      grep "person_id=123" logs/app.log | tail -20
      ```

      Look for: error messages, agency_id mismatches

   2. **Verify person exists in EventStore**:

      ```bash
      curl http://localhost:2113/streams/person-123
      ```

      Expected: Stream exists with events

   3. **Check JWT claims**:
      - Decode JWT token at jwt.io
      - Verify `agency_id` claim is present
      - Note the agency_id value

   4. **Check configuration**:

      ```bash
      env | grep EVENTSTORE
      ```

      Verify connection string is correct

   ### Hypothesis Testing (15-30 minutes)

   #### Test Hypothesis 1 (Cross-Agency Query)

   **Steps**:
   1. Add logging to `kurrent_client.rs:read_projection`:

      ```rust
      tracing::info!(
          "Reading projection: stream={}, user_agency={}, event_agency={}",
          stream_name,
          agency_id,
          event.metadata.agency_id
      );
      ```

   2. Reproduce the issue

   3. Check logs for agency_id mismatch

   **Expected outcome**:
   - If agency IDs don't match: Hypothesis confirmed (this is correct behavior)
   - If agency IDs match: Hypothesis rejected, move to next

   #### Test Hypothesis 2 (Stream Doesn't Exist)

   **Steps**:
   1. Query EventStore directly:

      ```bash
      curl http://localhost:2113/streams/person-123
      ```

   2. If 404: Stream doesn't exist
      - Check if person was created
      - Check command side logs for PersonCreated event

   3. If 200: Stream exists
      - Check event count
      - Hypothesis rejected, move to next

   #### Test Hypothesis 3 (Cache Key Mismatch)

   **Steps**:
   1. Add cache key logging:

      ```rust
      tracing::debug!("Cache get: key={}", cache_key);
      // ... later ...
      tracing::debug!("Cache set: key={}", cache_key);
      ```

   2. Trigger cache miss scenario

   3. Check if keys match exactly

   **Expected outcome**:
   - If keys differ: Hypothesis confirmed, fix key construction
   - If keys match: Hypothesis rejected

   ### Instrumentation Recommendations

   **Add logging**:

   ```rust
   // In person_service.rs
   tracing::debug!(
       "get_person_summary called: person_id={}, agency_id={}",
       person_id,
       agency_id
   );

   // In kurrent_client.rs
   tracing::debug!(
       "Reading stream: {}, events_found: {}, after_filter: {}",
       stream_name,
       total_events,
       filtered_events.len()
   );
   ```

   **Add metrics** (if using Prometheus):
   - `person_query_cache_hits` counter
   - `person_query_cache_misses` counter
   - `person_query_not_found` counter (by reason)

   **Write tests**:

   ```rust
   #[tokio::test]
   async fn test_cross_agency_query_returns_none() {
       // Person belongs to agency-A
       // Query with agency-B
       // Should return None (not error)
   }
   ```

   ***

   ## Recommended Next Steps
   1. **Start with Hypothesis 1** (most likely):
      - Add logging for agency_id comparison
      - Reproduce issue
      - Check if this is multi-tenancy filtering (correct behavior)

   2. **If Hypothesis 1 rejected, test Hypothesis 2**:
      - Query EventStore directly
      - Verify stream existence

   3. **Gather more data**:
      - Add comprehensive logging to all steps
      - Monitor for 24 hours
      - Analyze patterns (when does it happen?)

   4. **If still unclear after testing top hypotheses**:
      - Create minimal reproduction case
      - Write integration test that fails
      - Debug step-by-step with breakpoints

   ***

   ## Summary

   **Most Likely Cause**: Cross-agency query (multi-tenancy filtering working correctly)

   **Quick Verification**: Check if JWT agency_id matches event metadata agency_id

   **Confidence Level**: High (80%) - This pattern is consistent with multi-tenant system design

   **Estimated Debug Time**: 15-30 minutes to confirm hypothesis

   ```

   ```

9. **Validation**:

   **Before generating report**:
   - [ ] Entry point identified correctly
   - [ ] Execution path traced completely
   - [ ] Data flow analyzed
   - [ ] Error propagation understood
   - [ ] At least 3 hypotheses generated
   - [ ] Hypotheses ranked by probability
   - [ ] Verification steps provided
   - [ ] Investigation plan is actionable

## Edge Cases & Error Handling

**Incomplete information**:

- If error message vague, ask for more context
- If no stack trace, trace from likely entry points
- Note assumptions made in analysis

**Multiple possible paths**:

- If code has many branches, trace most likely path first
- Note alternative paths in report
- Suggest adding logging to determine actual path

**External dependencies**:

- If issue might be in external service, note this
- Provide steps to verify external service health
- Suggest monitoring/alerting for external dependencies

**Intermittent issues**:

- If issue is non-deterministic, suggest race condition analysis
- Recommend adding timing logs
- Suggest stress testing to reproduce

**No clear root cause**:

- Provide all plausible hypotheses
- Recommend systematic elimination
- Suggest writing failing test case

## Examples

### Example 1: Trace API 404 error

**Command**: `/trace-issue "GET /v1/persons/person-123 returns 404 but person exists"`

**Output**: (Generates comprehensive trace report as shown in step 8)

### Example 2: Trace from stack trace

**Command**:

```
/trace-issue "
thread 'main' panicked at 'called `Option::unwrap()` on a `None` value'
  at src/domain/services/person_service.rs:92:45
```

**Output**:

````
Analyzing panic location...

Entry point: src/domain/services/person_service.rs:92

Reading code context...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Issue Trace Report

**Issue**: Panic on unwrap() of None value
**Location**: src/domain/services/person_service.rs:92
**Root Cause**: Unsafe assumption about cache state

## Code Context

```rust
89: let cache_key = format!("person:{}:{}", agency_id, person_id);
90: let cached = self.cache.get(&cache_key);
91:
92: let person_data = cached.unwrap();  // ← PANIC HERE
93: Ok(Some((person_data, true)))
````

## Root Cause

**Direct cause**: Calling `.unwrap()` on `Option` that is `None`

**Why `cached` is None**:

- Cache miss (data not in cache or expired)
- Cache key doesn't exist

**Problem**: Code assumes cache always has data, but should handle miss

## Execution Path to Panic

1. Request arrives for person-123
2. Cache key constructed: "person:{agency_id}:person-123"
3. Cache lookup: `self.cache.get(&cache_key)`
4. Cache returns None (miss)
5. Code calls `.unwrap()` on None
6. ← PANIC

## Fix

**Immediate fix** (handle None case):

```rust
let cached = self.cache.get(&cache_key);

match cached {
    Some(data) => Ok(Some((data, true))),
    None => {
        // Cache miss - read from projection client
        let projection = self.projection_client
            .read_projection("person", person_id, agency_id)
            .await?;

        if let Some(data) = projection {
            self.cache.insert(cache_key, data.clone());
            Ok(Some((data, false)))
        } else {
            Ok(None)
        }
    }
}
```

**Better approach** (use `?` operator):

```rust
if let Some(cached) = self.cache.get(&cache_key) {
    return Ok(Some((cached, true)));
}

// Cache miss - read from projection
let projection = self.projection_client
    .read_projection("person", person_id, agency_id)
    .await?;

if let Some(data) = projection {
    self.cache.insert(cache_key.clone(), data.clone());
    Ok(Some((data, false)))
} else {
    Ok(None)
}
```

## Recommended Next Steps

1. Apply the fix above
2. Add test for cache miss scenario:

   ```rust
   #[tokio::test]
   async fn test_cache_miss_reads_from_projection() { ... }
   ```

3. Review codebase for other `.unwrap()` calls on Options
4. Consider using `unwrap_or`, `unwrap_or_else`, or pattern matching

```

### Example 3: Quick trace

**Command**: `/trace-issue "Cache returns stale data" --depth=quick`

**Output**:
```

Quick analysis of cache staleness...

## Likely Causes

1. **TTL too long** (24 hours)
   - Location: domain/services/person_service.rs:45
   - Fix: Reduce TTL or add manual invalidation

2. **Missing invalidation** after updates
   - Updates happen in command service
   - Query service cache not invalidated
   - Fix: Invalidate cache on PersonUpdated events

3. **Clock skew** between cache and data source
   - Cache timestamp vs EventStore timestamp
   - Fix: Use monotonic clock or version numbers

## Quick Checks

1. Check TTL: Look for cache configuration
2. Search for cache invalidation calls
3. Check if PersonUpdated events trigger invalidation

Run `/trace-issue "Cache returns stale data" --depth=thorough` for detailed analysis.

```

## Context

Additional user context: $ARGUMENTS
```
