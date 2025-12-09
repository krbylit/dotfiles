---
description: Generate comprehensive test scaffolding for implementation code following project patterns
allowed-tools: Read, Write, Bash
argument-hint: <file-path> [--type unit|integration|e2e]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command analyzes implementation code and generates comprehensive test scaffolding with test cases for happy paths, edge cases, error conditions, and edge cases, following project testing patterns and conventions.

### Execution Steps

1. **Parse Arguments**:
   - Extract file path to generate tests for
   - Extract test type (default: `unit`)
     - `unit`: Unit tests (test single function/method)
     - `integration`: Integration tests (test component integration)
     - `e2e`: End-to-end tests (test full user flows)
   - Validate file exists

2. **Analyze Implementation File**:

   Read and analyze:
   - File structure and organization
   - Public functions/methods
   - Input parameters and types
   - Return types
   - Error types
   - Dependencies (imports, injected services)
   - Complexity (branches, loops, error paths)

3. **Identify Project Testing Patterns**:

   **a. Find Existing Tests**:
   - Look for test files adjacent to implementation
   - Common patterns:
     - Same directory: `foo.test.ts`, `foo_test.rs`, `test_foo.py`
     - Test directory: `tests/foo_test.rs`, `__tests__/foo.test.ts`
     - Inline module: `#[cfg(test)] mod tests` (Rust)

   **b. Extract Testing Conventions**:
   - Test file naming pattern
   - Test function naming pattern
   - Assertion library used
   - Mocking framework
   - Test organization (describe/it, test modules, etc.)
   - Setup/teardown patterns

   **c. Check Test Configuration**:
   - Read `Cargo.toml`, `package.json`, `pytest.ini`, etc.
   - Note test dependencies
   - Check coverage requirements
   - Note test frameworks and versions

4. **Generate Test Cases**:

   For each public function/method, generate tests for:

   **a. Happy Path** (✅):
   - Normal, expected usage
   - Valid inputs
   - Expected outputs
   - At least 1 test per function

   **b. Edge Cases** (🔍):
   - Boundary values (min, max, zero, one)
   - Empty inputs (empty string, empty array, null)
   - Large inputs
   - Special characters
   - Typical edge conditions

   **c. Error Conditions** (❌):
   - Invalid inputs
   - Missing required parameters
   - Type mismatches
   - Business rule violations
   - Expected error types/messages

   **d. Integration Points** (🔗) (for integration tests):
   - Dependency interactions
   - Database queries
   - API calls
   - File I/O
   - External service calls

   **e. Concurrency** (⚡) (if applicable):
   - Concurrent access
   - Race conditions
   - Thread safety

5. **Generate Test File Structure**:

   Follow project patterns, typically:

   **Rust**:

   ```rust
   #[cfg(test)]
   mod tests {
       use super::*;
       // Test dependencies
       use mockito::Server;
       use tokio::test;

       // Test helper functions
       fn setup() -> TestContext { ... }

       // Test cases
       #[tokio::test]
       async fn test_function_name_happy_path() { ... }

       #[test]
       fn test_function_name_edge_case_empty_input() { ... }

       #[test]
       fn test_function_name_error_invalid_input() { ... }
   }
   ```

   **TypeScript/JavaScript**:

   ```typescript
   import { describe, it, expect, beforeEach, afterEach } from '@jest/globals';
   import { FunctionToTest } from './module';

   describe('FunctionToTest', () => {
     beforeEach(() => { /* setup */ });
     afterEach(() => { /* cleanup */ });

     it('should handle happy path correctly', () => { ... });

     it('should handle empty input gracefully', () => { ... });

     it('should throw error for invalid input', () => { ... });
   });
   ```

   **Python**:

   ```python
   import pytest
   from module import function_to_test

   class TestFunctionToTest:
       def setup_method(self):
           # Setup before each test
           pass

       def teardown_method(self):
           # Cleanup after each test
           pass

       def test_happy_path(self):
           # Test normal usage
           pass

       def test_edge_case_empty_input(self):
           # Test edge case
           pass

       def test_error_invalid_input(self):
           # Test error condition
           with pytest.raises(ValueError):
               function_to_test(invalid_input)
   ```

6. **Generate Test Implementations**:

   For each test case:

   **a. Arrange** (Setup):
   - Create test data
   - Mock dependencies
   - Set up environment

   **b. Act** (Execute):
   - Call function under test
   - Capture result or exception

   **c. Assert** (Verify):
   - Check return value
   - Verify side effects
   - Confirm error messages
   - Validate mock interactions

   **d. Cleanup** (if needed):
   - Release resources
   - Reset mocks
   - Clear test data

7. **Add Test Helpers**:

   Generate reusable helpers:
   - Mock object creators
   - Test data builders
   - Common assertions
   - Setup/teardown utilities

8. **Add Documentation**:

   For each test:
   - Clear test name describing scenario
   - Comment explaining what's being tested
   - Document any non-obvious test data
   - Note any assumptions or constraints

9. **Check Coverage**:

   Ensure tests cover:
   - All public functions
   - All code branches (if/else)
   - All error paths
   - All return value variants

10. **Write Test File**:
    - Create test file at appropriate location
    - Follow project naming convention
    - Include all generated tests
    - Add TODO comments for complex scenarios requiring manual implementation

11. **Report Results**:

    ```
    ✅ Test file generated: [path]

    📊 Test Coverage:
    - Functions tested: [count]
    - Happy path tests: [count]
    - Edge case tests: [count]
    - Error condition tests: [count]
    - Total test cases: [count]

    📝 Next Steps:
    1. Review generated tests
    2. Implement TODO test cases
    3. Run tests: [command]
    4. Check coverage: [command]
    ```

## Test Generation Strategy

### Analyzing Function Complexity

**Simple Function** (1-3 tests):

```rust
fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

Tests:

- Happy path: normal addition
- Edge case: overflow handling
- Edge case: negative numbers

**Medium Function** (4-7 tests):

```rust
fn get_person(id: &str, agency_id: &str) -> Result<Person, Error> {
    validate_id(id)?;
    let person = db.query(id, agency_id)?;
    Ok(person)
}
```

Tests:

- Happy path: valid id returns person
- Edge case: empty id
- Edge case: missing person (returns None)
- Error: invalid id format
- Error: database error
- Security: cross-agency access attempt

**Complex Function** (8+ tests):

```rust
async fn cache_get_or_load<F>(
    &self,
    key: &str,
    loader: F
) -> Result<Value, Error>
where F: Fn() -> Future<Output = Result<Value, Error>>
{
    if let Some(cached) = self.cache.get(key) {
        return Ok(cached);
    }
    let value = loader().await?;
    self.cache.set(key, value.clone());
    Ok(value)
}
```

Tests:

- Happy path: cache hit
- Happy path: cache miss, load success
- Edge case: concurrent cache misses
- Edge case: cache eviction during load
- Error: loader error doesn't cache
- Error: cache error falls back to loader
- Performance: verify single load on concurrent misses
- TTL: verify expiration

### Test Naming Conventions

**Pattern**: `test_<function>_<scenario>_<expected_outcome>`

**Examples**:

```rust
// Rust
#[test]
fn test_validate_email_valid_format_returns_ok() { }

#[test]
fn test_validate_email_missing_at_symbol_returns_error() { }

#[test]
fn test_get_person_cache_hit_returns_cached_data() { }
```

```typescript
// TypeScript
it("should return person when cache hit", () => {});

it("should load from database on cache miss", () => {});

it("should throw error when person not found", () => {});
```

```python
# Python
def test_validate_email_valid_format_returns_true(self):
    pass

def test_validate_email_invalid_format_returns_false(self):
    pass
```

### Mock Generation

Generate appropriate mocks for dependencies:

**Rust** (using mockall or manual traits):

```rust
struct MockProjectionClient {
    response: Option<Value>,
    error: Option<Error>,
}

#[async_trait]
impl ProjectionClient for MockProjectionClient {
    async fn read_projection(&self, ...) -> Result<Option<Value>, Error> {
        if let Some(err) = &self.error {
            return Err(err.clone());
        }
        Ok(self.response.clone())
    }
}
```

**TypeScript** (using jest):

```typescript
const mockProjectionClient = {
  readProjection: jest.fn(),
};

// In test:
mockProjectionClient.readProjection.mockResolvedValue(personData);
```

**Python** (using unittest.mock):

```python
from unittest.mock import Mock, patch

@patch('module.ProjectionClient')
def test_with_mock(mock_client):
    mock_client.read_projection.return_value = person_data
    # Test code
```

### Test Data Builders

Generate helpers for creating test data:

```rust
// Rust
fn mock_person_summary(id: &str) -> PersonSummaryData {
    PersonSummaryData {
        person_id: id.to_string(),
        first_name: "John".to_string(),
        last_name: "Doe".to_string(),
        // ... other fields with defaults
    }
}

fn mock_person_with_operations(id: &str, op_count: usize) -> PersonSummaryData {
    let mut person = mock_person_summary(id);
    person.operations = (0..op_count)
        .map(|i| mock_operation(&format!("op-{}", i)))
        .collect();
    person
}
```

```typescript
// TypeScript
const personBuilder = {
  default: (): Person => ({
    id: "person-123",
    firstName: "John",
    lastName: "Doe",
    // ... defaults
  }),

  withOperations: (count: number): Person => ({
    ...personBuilder.default(),
    operations: Array.from({ length: count }, (_, i) => ({
      id: `op-${i}`,
      // ...
    })),
  }),
};
```

## Language-Specific Patterns

### Rust

**Testing Async Code**:

```rust
#[tokio::test]
async fn test_async_function() {
    let result = async_function().await;
    assert!(result.is_ok());
}
```

**Testing Results**:

```rust
#[test]
fn test_returns_error() {
    let result = function_that_errors();
    assert!(result.is_err());
    assert_eq!(result.unwrap_err(), ExpectedError::InvalidInput);
}
```

**Testing Panics**:

```rust
#[test]
#[should_panic(expected = "index out of bounds")]
fn test_panics_on_invalid_index() {
    let _ = vec![1, 2, 3][10];
}
```

### TypeScript/JavaScript

**Testing Promises**:

```typescript
it("should resolve with data", async () => {
  await expect(asyncFunction()).resolves.toEqual(expectedData);
});

it("should reject with error", async () => {
  await expect(asyncFunction()).rejects.toThrow("Error message");
});
```

**Testing Exceptions**:

```typescript
it("should throw on invalid input", () => {
  expect(() => functionThatThrows()).toThrow("Invalid input");
});
```

**Snapshot Testing**:

```typescript
it("should match snapshot", () => {
  expect(component).toMatchSnapshot();
});
```

### Python

**Testing Exceptions**:

```python
def test_raises_value_error(self):
    with pytest.raises(ValueError, match="Invalid input"):
        function_that_raises()
```

**Parametrized Tests**:

```python
@pytest.mark.parametrize("input,expected", [
    ("valid@email.com", True),
    ("invalid", False),
    ("", False),
])
def test_validate_email(input, expected):
    assert validate_email(input) == expected
```

**Fixtures**:

```python
@pytest.fixture
def person_data():
    return {
        'id': 'person-123',
        'first_name': 'John',
        'last_name': 'Doe',
    }

def test_with_fixture(person_data):
    result = process_person(person_data)
    assert result is not None
```

## Edge Cases & Error Handling

**File Not Found**:

- Error with helpful message
- Suggest using file browser or glob pattern
- List similar files

**No Public Functions**:

- ERROR: "No testable public functions found in [file]"
- Suggest checking file path or module visibility

**Tests Already Exist**:

- Detect existing test file
- Option to:
  - Append new tests
  - Overwrite (with confirmation)
  - Create alternative test file
  - Cancel

**Complex Dependencies**:

- If function has many dependencies, note in TODO
- Generate mock interfaces
- Provide guidance on setting up mocks
- Suggest integration test instead

**Cannot Infer Test Cases**:

- For very complex business logic
- Generate skeleton tests with TODO comments
- Provide guidance on what to test
- Ask user for input on test scenarios

## Validation

Before writing test file, verify:

- [ ] All public functions have at least one test
- [ ] Each function has happy path test
- [ ] Error conditions are tested
- [ ] Edge cases are covered
- [ ] Mocks are properly structured
- [ ] Test names are descriptive
- [ ] Test file follows project conventions
- [ ] Dependencies are imported correctly
- [ ] No syntax errors in generated code

## Example Output

```markdown
✅ Test file generated: src/domain/services/person_service.rs (test module)

📊 Test Coverage Generated:

### PersonQueryService

**get_person_summary**:

- ✅ Happy path: cache hit returns cached data
- ✅ Happy path: cache miss loads from projection client
- ✅ Edge case: missing person returns None
- ✅ Error: projection client error propagated
- ✅ Error: invalid person_id format
- ✅ Security: cross-agency access returns None

**invalidate_cache**:

- ✅ Happy path: existing key invalidated
- ✅ Edge case: non-existent key (no-op)
- ✅ Edge case: concurrent invalidation

**Total**: 3 functions, 9 test cases

### Generated Helpers:

- `mock_projection_client()` - Creates test projection client
- `mock_person_data()` - Creates sample person data
- `setup_service()` - Creates service with mocks

📝 Next Steps:

1. Review generated tests in test module
2. Implement TODO test cases (marked with // TODO)
3. Run tests: `cargo test person_service`
4. Check coverage: `cargo tarpaulin --packages leads-queries --lib`

💡 Notes:

- Tests follow existing project patterns
- Mocks use manual trait implementation (consistent with project)
- Async tests use `#[tokio::test]` attribute
- All tests include descriptive comments

⚠️ Manual Implementation Needed:

- TODO: Concurrent cache access test (requires advanced mock setup)
- TODO: Cache TTL expiration test (requires time mocking)
```

## Context

User-provided arguments: $ARGUMENTS

## Notes

- **Follow project patterns**: Don't impose different testing style
- **Be comprehensive**: Cover happy path, edge cases, errors
- **Make it runnable**: Generated tests should compile/run (even if failing)
- **Provide value**: Don't just generate boilerplate - include meaningful assertions
- **Document complexity**: Add TODO comments for tests requiring manual implementation
- **Test names matter**: Use descriptive names that explain the scenario
- **Mock appropriately**: Generate mocks that are useful and realistic
- **Think like a tester**: What could go wrong? Test that!
