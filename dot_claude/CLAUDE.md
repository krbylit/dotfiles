# Claude Assistant Guide for All Projects

## General Commands

- Prioritize finding what actually works. If an approach has flaws, point them out directly - we're debugging ideas together, not defending them. Challenge assumptions, including mine.
- Before you proceed, confirm you understand and tell me your plan. Do not make assumptions; ask questions if anything is unclear.
- When you make an error, explicitly acknowledge it and explain what went wrong

## Explaining Decisions

- For non-obvious technical choices, briefly explain the reasoning
- When trade-offs exist (performance vs readability, etc.), state which you chose and why
- If you're unsure between approaches, present options rather than picking arbitrarily

## Development Commands

- When modifying existing code, read the file first to understand context and patterns
- Before starting multi-file changes, outline the approach and wait for confirmation
- If a change might break existing functionality, flag it explicitly
- When adding dependencies, explain why existing solutions won't work
- For bug fixes, explain the root cause before proposing the solution
- `git commit` every individual file you edit/create in an isolated commit. The commit message must follow the conventional commit style (e.g. `feat: add user login`), with a commit subject line no longer than 50 characters, and must also include a commit body message with detailed explanation of the changes made and justification for them.
  - If you are unable to `git commit`, then provide the commit message as a multi-line comment at the very top of the file.
- Always follow patterns established elsewhere in the code, unless asked specifically to do something a certain way.
- Do what has been asked; nothing more, nothing less.
- Before creating new files, check if the functionality logically belongs in an existing file
- Follow the project's existing file organization patterns - don't fragment related code unnecessarily
- If similar utilities/helpers/components exist, extend those rather than creating parallel implementations
- When in doubt, add to existing modules rather than proliferating new ones
- NEVER use `git push`, `git push --force`, or `git push --force-with-lease` - you MUST stop and ask the user if force push looks like the only viable route
- Keep commits small and focused - if a change involves multiple unrelated fixes, split into separate commits
- Prefer explicit over implicit - clear variable names, obvious control flow

## Testing & Validation

- **CRITICAL: NEVER run tests without first reading the project's testing documentation**
- Testing procedures vary by repository and improper execution can destroy production data
- Always search for testing instructions in README files (root, test dir, docs, .github)
- Common patterns: Docker-based test DBs, specific env vars, custom test runners
- When creating or modifying tests, strictly follow the existing test structure and framework used in that specific repository
- If testing documentation is unclear or missing, ask before proceeding
- For bug fixes, consider if a test should be added to prevent regression, but only after understanding the testing framework

### Test Integrity

- **A trivial passing test is worse than a failing real test** - never weaken tests to make them pass
- If a test won't pass after multiple legitimate attempts, stop and explain the problem
- Do not change assertions to test obvious truths or remove the actual conditions being tested
- Do not mock out the real functionality being tested unless that was the original test design
- When stuck: describe what you've tried, why it failed, and ask for direction
- Preserving test validity is more important than having all tests pass

## Code Quality

- You write code that is easily understandable, efficient, maintainable, modular, and above all, that follows the conventions of the rest of the code in the project.
- Handle errors appropriately for the context (don't just add try-catch everywhere)
- Consider edge cases, but don't over-engineer for hypothetical scenarios
- Optimize only when there's a clear need; prefer clarity over cleverness
- Remove debug code (console.log, print statements, commented code) before committing
- Write helpful error messages that aid debugging - include context about what failed and why
- For APIs or shared interfaces, consider backwards compatibility before making breaking changes, unless instructed otherwise
