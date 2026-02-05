# PR Review Comment Examples

This guide provides examples of effective PR review comments following the skill's style guidelines.

## Core Principles

1. **Brevity with Precision**: 1-3 sentences maximum
2. **Collaborative Tone**: Use softening language
3. **Direct Problem Identification**: Be specific
4. **Question-Driven for Architecture**: Ask questions for design decisions
5. **Provide Context**: Explain "why" when non-obvious
6. **Acknowledge Tradeoffs**: Note scope limitations
7. **Include Code Suggestions**: Provide concrete examples
8. **Scale with Complexity**: Adjust detail level
9. **Professional and Respectful**: Always collaborative
10. **Reference Related Context**: Link to similar patterns

## Examples by Category

### Simple Validation Issues

**Null Reference**:
> I think there's a possible null reference here.

**Type Checking**:
> This assumes `data` is always an array, but it could be undefined.

**Boundary Checking**:
> Off-by-one error: the loop should use `i < array.length` instead of `i <= array.length`.

### Security Issues

**SQL Injection**:
> Potential SQL injection. Use parameterized query: `$1, $2` instead of string interpolation.

**XSS Vulnerability**:
> User input isn't sanitized before rendering. This could allow XSS attacks.

**Auth Bypass**:
> I believe this endpoint bypasses authentication checks. Can we verify the user's session before processing?

**Sensitive Data**:
> This logs the full user object including password hash. Consider logging only user ID.

### Performance Issues

**Algorithmic Complexity**:
> This nested loop is O(n²). Consider using a HashSet for O(n) lookup:
> ```javascript
> const idSet = new Set(items.map(i => i.id));
> return users.filter(u => idSet.has(u.id));
> ```

**N+1 Query**:
> This creates an N+1 query problem - one query per user. Can we eager load with a join or `includes`?

**Blocking Operation**:
> This blocks the async runtime. Use `tokio::spawn_blocking` for CPU-intensive work to prevent starving other tasks.

**Unnecessary Computation**:
> This recalculates `expensiveFunction()` in every loop iteration. Can we hoist it outside?

### Architectural / Design Issues

**Pattern Consistency**:
> I think it may be safer to use the factory pattern for this, like `userModel.js` and `upload.js` does.

**Separation of Concerns**:
> This controller method contains business logic that should live in the service layer. Can we extract it?

**Dependency Management**:
> I think it is actually beneficial to use `urllib` here like was suggested. It's part of standard library, so we don't have to worry about dependency creep.

**Error Handling Pattern**:
> Can we use the established error handling pattern from `auth.service.ts`? That seems to follow the established pattern more closely.

### Race Conditions / Concurrency

**Race Condition**:
> I think this may guard against a possible race completely. As unlikely as it is, I believe a very quick double click could still trigger the race.

**Infinite Loop**:
> I think there's possible infinite render recursion with watching just `roi`.

**Unnecessary Re-renders**:
> Are all of these really required in the dependency array? This worries me about high potential for unnecessary re-renders.

### Testing Issues

**Missing Test Coverage**:
> This error path isn't tested. Can we add a test case for when the API returns 500?

**Test Quality**:
> This test mocks the entire function being tested. We should test the real implementation.

**Edge Case**:
> The tests don't cover the empty array case. That's likely where bugs will surface.

### Documentation Issues

**Missing Docs**:
> This public API lacks JSDoc. Can we document the parameters and return type?

**Complex Logic**:
> This algorithm is non-obvious. A brief comment explaining the approach would help future maintainers.

**Breaking Change**:
> This changes the signature of a public method. Should we document this as a breaking change in CHANGELOG?

### Maintainability Issues

**Code Duplication**:
> This logic duplicates the implementation in `formatUser()`. Can we extract a shared helper?

**Magic Numbers**:
> What does `86400` represent? Consider: `const SECONDS_PER_DAY = 86400`.

**Function Length**:
> This function is 150 lines. Can we extract some of the validation logic into helper functions?

**Naming**:
> `data` is vague. Consider `userProfile` or `accountDetails` to clarify intent.

### Scope & Tradeoffs

**Out of Scope**:
> Yeah, it's an unfortunate hack, but I believe out of scope for this one. I believe it also may have less affect on results returned than it seems.

**Worth Fixing**:
> Unlikely as the edge cases are, it's not expensive to handle them here.

**Auto-Generated Code**:
> I believe these are actually generated with `source_merger.py` and shouldn't be edited by hand anyway.

### Positive Feedback

**Good Catch**:
> Good catch on this edge case - I wouldn't have thought of that.

**Well Done**:
> Excellent test coverage for this new feature. Really thorough.

**Smart Optimization**:
> Nice use of memoization here - this should significantly improve performance.

**Clear Code**:
> This refactor makes the code much more readable. Good call.

## Anti-Patterns to Avoid

### ❌ Too Vague
> This code is bad.

### ✅ Specific and Actionable
> This nested loop is O(n²). Consider using a HashSet for O(n) lookup.

---

### ❌ Condescending
> You should know better than to do this.

### ✅ Collaborative
> I think there might be a better approach here. Can we try...?

---

### ❌ No Context
> Fix this.

### ✅ Explained Impact
> This will panic if `user_id` is null. Add validation: `if user_id.is_none() { return Err(...) }`

---

### ❌ Overly Prescriptive (when unnecessary)
> You must refactor this into 5 separate functions with these exact names...

### ✅ Suggests Improvement
> This function is getting long. Consider extracting the validation logic into a helper.

---

### ❌ Only Criticism
> This has security issues, performance problems, and poor naming.

### ✅ Balanced Feedback
> Security concern: this needs input validation. Otherwise, the caching strategy looks solid.

## Language-Specific Examples

### Rust

**Ownership Issue**:
> This moves `data` into the closure. If we need it later, consider using `data.clone()` or restructuring to borrow.

**Unwrap Usage**:
> `.unwrap()` will panic on error. Use `?` operator or `match` for proper error handling.

**Lifetime Annotation**:
> The lifetime annotation here seems unnecessary. Rust can infer it from the function signature.

### JavaScript/TypeScript

**Type Safety**:
> `any` disables type checking. Can we use a proper interface here?

**Async/Await**:
> This `async` function doesn't `await` anything. Can we make it synchronous?

**Promise Error**:
> Unhandled promise rejection. Add `.catch()` or wrap in try-catch.

### Python

**Type Hints**:
> Type hints would help here: `def process_user(user: User) -> Dict[str, Any]:`.

**Exception Handling**:
> Bare `except:` catches all exceptions including system exits. Use `except Exception:` instead.

**List Comprehension**:
> This loop could be a list comprehension: `valid_ids = [u.id for u in users if u.active]`.

### Go

**Error Check**:
> Missing error check after `file.Read()`. Should handle potential I/O errors.

**Goroutine Leak**:
> This goroutine never exits. Consider adding a context for cancellation.

**Defer Placement**:
> `defer file.Close()` should come right after the successful open, not at the end of the function.

## Contextual References

### Reference Similar Code

> Can we use the same pattern as `auth/middleware.ts`? That approach handles errors more consistently.

### Reference Previous Discussion

> Just noticed this from the Copilot comment on #964 - we decided to avoid this pattern.

### Reference Standards

> Per the project's CLAUDE.md, we should use factory functions instead of classes for models.

### Reference External Context

> According to the React docs, this hook dependency array will cause infinite re-renders.

## Scaling Comment Detail

### Simple Fix (5-10 words)
> Missing semicolon on line 42.

### Bug (1-2 sentences)
> This will crash when `user` is null. Add a null check before accessing `user.name`.

### Security Issue (2-3 sentences)
> User input goes directly into SQL query. This is vulnerable to SQL injection. Use parameterized queries instead: `db.query("SELECT * FROM users WHERE id = ?", [userId])`.

### Architecture Discussion (3-5 sentences)
> This puts business logic in the controller layer. Per our architecture guidelines, business logic should live in service classes. Can we move this to `UserService` and have the controller just handle HTTP concerns? This would also make the logic testable without spinning up the HTTP server.

### Complex Refactoring (5-8 sentences with examples)
> This function has multiple responsibilities: validation, transformation, database access, and error handling. Consider the single responsibility principle. We could split this into:
> ```typescript
> function validateInput(data: unknown): UserInput { /* ... */ }
> function transformUser(input: UserInput): User { /* ... */ }
> function saveUser(user: User): Promise<void> { /* ... */ }
> ```
> This would make each piece testable in isolation and easier to understand. The main function would just orchestrate these steps.
