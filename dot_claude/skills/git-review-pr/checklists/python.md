# Python Code Review Checklist

## Type Hints

- [ ] Type hints on all function signatures
- [ ] Return types specified
- [ ] Complex types use `typing` module (`List`, `Dict`, `Optional`, etc.)
- [ ] `mypy` checks pass
- [ ] Generic types used where appropriate
- [ ] Protocol classes for duck typing

## Error Handling

- [ ] Specific exception types caught (not bare `except:`)
- [ ] Exceptions inherit from appropriate base classes
- [ ] Context preserved when re-raising (`raise ... from`)
- [ ] Resources cleaned up in `finally` or with context managers
- [ ] Custom exceptions defined for domain errors

## Code Style (PEP 8)

- [ ] 4-space indentation
- [ ] Snake_case for functions/variables, CamelCase for classes
- [ ] Line length ≤ 88 characters (Black) or ≤ 79 (PEP 8)
- [ ] Docstrings for public functions/classes
- [ ] Imports organized (stdlib, third-party, local)
- [ ] `black` or `autopep8` applied

## Pythonic Code

- [ ] List comprehensions instead of loops where readable
- [ ] Generators for lazy evaluation (`yield`)
- [ ] Context managers (`with` statement) for resources
- [ ] `enumerate()` instead of range(len())
- [ ] `zip()` for parallel iteration
- [ ] `any()`/`all()` for boolean reductions
- [ ] f-strings for formatting (Python 3.6+)

## Performance

- [ ] No premature optimization
- [ ] Appropriate data structures (set for membership, deque for queues)
- [ ] Avoid repeated expensive operations in loops
- [ ] `functools.lru_cache` for memoization
- [ ] Generators for large datasets
- [ ] NumPy/Pandas for numerical operations

## Async/Await (if applicable)

- [ ] `async`/`await` used correctly
- [ ] No blocking calls in async functions
- [ ] Proper use of `asyncio.gather` for concurrency
- [ ] Event loop managed correctly
- [ ] Timeouts specified for network operations

## Testing

- [ ] Pytest for all tests
- [ ] Test functions start with `test_`
- [ ] Fixtures used for setup/teardown
- [ ] Mocks used appropriately (`unittest.mock`)
- [ ] Parametrize for multiple test cases
- [ ] Edge cases tested
- [ ] Coverage >80% for critical code

## Security

- [ ] No SQL injection (use parameterized queries)
- [ ] Input validation for all external data
- [ ] Secrets in environment variables, not code
- [ ] `secrets` module for cryptographic randomness
- [ ] Pickle used carefully (or not at all)
- [ ] Path traversal prevented

## Dependencies

- [ ] `requirements.txt` or `pyproject.toml` up to date
- [ ] Pinned versions for reproducibility
- [ ] No unused dependencies
- [ ] Virtual environment used
- [ ] Security vulnerabilities checked (`safety`, `pip-audit`)

## Documentation

- [ ] Docstrings follow Google or NumPy style
- [ ] README with installation/usage
- [ ] Complex algorithms explained
- [ ] Public API documented
- [ ] Examples provided

## Common Anti-Patterns to Avoid

- [ ] No mutable default arguments (`def func(x=[]):`)
- [ ] No bare `except:` clauses
- [ ] No `exec()` or `eval()` with user input
- [ ] No global state where avoidable
- [ ] No circular imports
- [ ] No shadowing built-ins (`list`, `dict`, `id`, etc.)

## Modern Python (3.8+)

- [ ] Walrus operator (`:=`) for efficiency
- [ ] Positional-only (`/`) and keyword-only (`*`) parameters
- [ ] `match`/`case` for pattern matching (3.10+)
- [ ] Type unions with `|` syntax (3.10+)
- [ ] `Self` type hint (3.11+)
