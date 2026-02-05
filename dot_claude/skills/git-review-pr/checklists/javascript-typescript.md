# JavaScript/TypeScript Code Review Checklist

## Type Safety (TypeScript)

- [ ] No use of `any` (use `unknown` or proper types)
- [ ] Interfaces/types defined for complex objects
- [ ] Proper use of generics for reusable code
- [ ] Union types used instead of overly broad types
- [ ] Type guards for runtime type checks
- [ ] `strict` mode enabled in `tsconfig.json`

## Null/Undefined Handling

- [ ] Optional chaining (`?.`) used appropriately
- [ ] Nullish coalescing (`??`) instead of `||` for defaults
- [ ] No assumptions about value existence
- [ ] Proper null/undefined checks before access
- [ ] TypeScript's `strictNullChecks` respected

## Async/Await

- [ ] Promises handled with `async`/`await` (not `.then()` chains)
- [ ] Error handling with `try`/`catch` for async operations
- [ ] No unhandled promise rejections
- [ ] `Promise.all` used for parallel operations
- [ ] No mixing of callbacks and promises
- [ ] Proper cancellation for long-running operations

## Performance

- [ ] No unnecessary re-renders (React: memo, useMemo, useCallback)
- [ ] Debouncing/throttling for expensive operations
- [ ] Lazy loading for large components/modules
- [ ] Code splitting for bundle optimization
- [ ] No memory leaks (event listeners cleaned up)
- [ ] Avoid blocking the main thread

## Memory Leaks

- [ ] Event listeners removed in cleanup
- [ ] Subscriptions unsubscribed
- [ ] Timers cleared (`clearTimeout`, `clearInterval`)
- [ ] WeakMap/WeakSet used for object caching
- [ ] Closures don't capture unnecessary variables

## React-Specific (if applicable)

- [ ] Keys used correctly in lists (not array index)
- [ ] Hooks follow Rules of Hooks
- [ ] Dependency arrays complete and accurate
- [ ] State updates are immutable
- [ ] No side effects in render
- [ ] Proper use of `useEffect` cleanup
- [ ] Context used appropriately (not for all state)

## Error Handling

- [ ] Errors caught and handled appropriately
- [ ] User-friendly error messages
- [ ] Error boundaries in React apps
- [ ] Logging for debugging (but not sensitive data)
- [ ] Graceful degradation for failed operations

## Security

- [ ] XSS prevention (no `dangerouslySetInnerHTML` without sanitization)
- [ ] CSRF protection for state-changing operations
- [ ] Input validation on client and server
- [ ] No eval() or Function() constructor with user input
- [ ] Secrets not in client-side code
- [ ] Proper authentication/authorization checks

## Code Quality

- [ ] ESLint rules followed
- [ ] Prettier formatting applied
- [ ] Functions are small and focused
- [ ] Meaningful variable/function names
- [ ] No magic numbers (use constants)
- [ ] Comments explain "why", not "what"

## Testing

- [ ] Unit tests for business logic
- [ ] Integration tests for API calls
- [ ] Component tests for UI (React Testing Library)
- [ ] E2E tests for critical flows
- [ ] Mocks used appropriately (not over-mocked)
- [ ] Test coverage for error paths

## Modern JavaScript

- [ ] `const`/`let` used (no `var`)
- [ ] Arrow functions for callbacks
- [ ] Destructuring for cleaner code
- [ ] Template literals instead of string concatenation
- [ ] Spread operator for immutable updates
- [ ] Modules (import/export) used correctly

## Bundle Size

- [ ] Tree-shaking enabled
- [ ] Heavy dependencies avoided or lazy-loaded
- [ ] Images optimized
- [ ] CSS purged of unused styles
- [ ] Source maps in production (if needed)
