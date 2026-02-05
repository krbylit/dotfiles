# Go Code Review Checklist

## Error Handling

- [ ] All errors checked (no ignored `err`)
- [ ] Errors wrapped with context (`fmt.Errorf` with `%w`)
- [ ] Custom error types for domain errors
- [ ] `errors.Is` and `errors.As` used for error checking
- [ ] Error messages start with lowercase (unless proper noun)
- [ ] Sentinel errors exported and documented

## Nil Checks

- [ ] Nil checks before dereferencing pointers
- [ ] Nil interface values handled correctly
- [ ] Nil slices/maps checked before use
- [ ] Defensive programming against nil returns

## Goroutines & Concurrency

- [ ] No goroutine leaks (all goroutines have exit path)
- [ ] Proper use of channels (buffered vs unbuffered)
- [ ] Channel direction specified in function signatures
- [ ] `select` with `default` for non-blocking operations
- [ ] Context used for cancellation
- [ ] `sync.WaitGroup` used correctly
- [ ] Data races prevented (run `go test -race`)

## Context

- [ ] Context passed as first parameter
- [ ] Context not stored in structs
- [ ] Timeouts set with `context.WithTimeout`
- [ ] Context cancellation checked in loops
- [ ] Context values used sparingly (only for request-scoped data)

## Defer

- [ ] Resources cleaned up with `defer` (file.Close(), mutex.Unlock())
- [ ] `defer` called immediately after resource acquisition
- [ ] No `defer` in loops (causes buildup)
- [ ] Defer errors checked when necessary

## Mutexes & Synchronization

- [ ] Mutex locks have corresponding unlocks
- [ ] `defer mutex.Unlock()` after lock
- [ ] Read locks (`RLock`) used for read-only access
- [ ] No recursive locking (deadlock risk)
- [ ] Proper use of `sync.Once` for initialization

## Slices & Maps

- [ ] Slice capacity pre-allocated when size known (`make([]T, 0, n)`)
- [ ] No slice/map concurrent read/write without synchronization
- [ ] Slice bounds checked to avoid panics
- [ ] Maps checked for key existence before access
- [ ] Nil maps cannot be assigned to (use `make`)

## Interfaces

- [ ] Interfaces defined where used, not where implemented
- [ ] Small, focused interfaces (interface segregation)
- [ ] Accept interfaces, return structs
- [ ] Avoid interface{} when possible (use generics in Go 1.18+)
- [ ] Type assertions/switches have safety checks

## Naming Conventions

- [ ] CamelCase for exported, camelCase for unexported
- [ ] Short names in limited scope (`i`, `err`, `ctx`)
- [ ] Descriptive names in broader scope
- [ ] Package name singular, lowercase, no underscores
- [ ] No stutter (avoid `user.UserID`, prefer `user.ID`)

## Testing

- [ ] Test functions start with `Test`
- [ ] Table-driven tests for multiple cases
- [ ] `t.Helper()` used in test helpers
- [ ] Tests run with `-race` flag
- [ ] Mocks/stubs for external dependencies
- [ ] Error paths tested
- [ ] Examples in tests for documentation

## Performance

- [ ] `strings.Builder` for concatenation in loops
- [ ] `sync.Pool` for frequent allocations
- [ ] Avoid allocations in hot paths
- [ ] Benchmark tests for critical code
- [ ] Profile before optimizing (`pprof`)

## Error Messages

- [ ] Start with lowercase (unless proper noun)
- [ ] No trailing punctuation
- [ ] Include context (what failed, why)
- [ ] No "error:", "failed:", etc. prefix (redundant)

## Code Organization

- [ ] Packages have clear, single responsibility
- [ ] Internal packages for non-exported code
- [ ] Cyclic dependencies avoided
- [ ] Main package minimal (orchestration only)

## Best Practices

- [ ] `gofmt` applied (or `goimports`)
- [ ] `golangci-lint` passes
- [ ] No naked returns in long functions
- [ ] Avoid `init()` functions when possible
- [ ] Constants for "magic numbers"
- [ ] Structs initialized with field names
- [ ] Zero values useful (design for it)

## Security

- [ ] Input validation for external data
- [ ] No command injection (validate shell commands)
- [ ] Crypto uses secure functions (`crypto/rand`, not `math/rand`)
- [ ] Secrets in environment variables
- [ ] SQL injection prevented (use parameterized queries)

## Common Mistakes to Avoid

- [ ] No goroutines without exit strategy
- [ ] Don't ignore context cancellation
- [ ] No defer in infinite loops
- [ ] Check slice length before indexing
- [ ] Don't compare `error` with `==` (use `errors.Is`)
- [ ] Don't use `panic` for normal errors
