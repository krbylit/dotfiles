# Rust Code Review Checklist

## Ownership & Borrowing

- [ ] No unnecessary clones (`.clone()` when borrowing would work)
- [ ] Correct lifetime annotations (not overly restrictive)
- [ ] No dangling references or use-after-move
- [ ] Appropriate use of `&`, `&mut`, and owned values
- [ ] Smart use of `Cow`, `Rc`, `Arc` when needed

## Error Handling

- [ ] Uses `Result<T, E>` for fallible operations
- [ ] Uses `Option<T>` for optional values
- [ ] Avoids `.unwrap()` and `.expect()` in production code
- [ ] Proper error propagation with `?` operator
- [ ] Custom error types with context when appropriate
- [ ] `anyhow` or `thiserror` used correctly

## Safety & Correctness

- [ ] Unsafe code justified with SAFETY comments
- [ ] No data races or undefined behavior in unsafe blocks
- [ ] Panic potential clearly documented
- [ ] Integer overflow handled (wrapping vs saturating vs checked)
- [ ] No off-by-one errors in indexing

## Performance

- [ ] No unnecessary allocations (use `&str` not `String` when possible)
- [ ] Iterators used instead of loops where appropriate
- [ ] `Vec::with_capacity` used when size is known
- [ ] No redundant clones in hot paths
- [ ] Zero-copy deserialization considered
- [ ] Proper use of `#[inline]` for small functions

## Concurrency

- [ ] `Send` and `Sync` traits correctly implemented
- [ ] No data races in concurrent code
- [ ] Proper use of `Mutex`, `RwLock`, atomics
- [ ] Channels used correctly (`mpsc`, `crossbeam`)
- [ ] Async code uses `.await` appropriately
- [ ] No blocking operations in async contexts

## API Design

- [ ] Public API well-documented with examples
- [ ] Follows Rust naming conventions (`snake_case`, `CamelCase`)
- [ ] Builder pattern for complex constructors
- [ ] Traits used for abstraction where appropriate
- [ ] Const generics used when beneficial
- [ ] `Into`/`From` traits implemented for conversions

## Testing

- [ ] Unit tests for all public functions
- [ ] Doctests for public APIs with examples
- [ ] Property tests for complex logic
- [ ] Integration tests for crate-level behavior
- [ ] Error cases tested

## Code Quality

- [ ] No compiler warnings
- [ ] `clippy` lints pass
- [ ] `rustfmt` applied consistently
- [ ] No overly complex functions (>50 lines)
- [ ] Pattern matching preferred over conditionals
- [ ] Enums used for state machines

## Dependencies

- [ ] Minimal dependency footprint
- [ ] No deprecated crates
- [ ] Feature flags used to reduce bloat
- [ ] Versions properly constrained in `Cargo.toml`
