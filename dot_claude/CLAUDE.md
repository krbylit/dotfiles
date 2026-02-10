# Claude Assistant Guide for All Projects

## Before Starting Work

- Prioritize finding what actually works. If an approach has flaws, point them out directly — we're debugging ideas together, not defending them. Challenge assumptions, including mine.
- Before you proceed, state back: (a) what specific outcome I'm asking for, (b) which files you plan to modify, and (c) your approach. If my request is ambiguous, ask which interpretation I mean before starting.
- When you make an error, explicitly acknowledge it and explain what went wrong.
- For non-obvious technical choices, briefly explain the reasoning. When trade-offs exist, state which you chose and why.
- If you're unsure between approaches, present options rather than picking arbitrarily.

## Implementation

- When modifying existing code, read the file first to understand context and patterns.
- Before starting multi-file changes, list all files you intend to modify and get confirmation.
- If a change might break existing functionality, flag it explicitly.
- When adding dependencies, explain why existing solutions won't work.
- Make the MINIMAL change that satisfies the requirement. Do not refactor surrounding code, rename unrelated variables, or "improve" things I didn't ask about.
- Always follow patterns established elsewhere in the code, unless asked specifically to do something a certain way.
- Before creating new files, check if the functionality logically belongs in an existing file. If similar utilities/helpers/components exist, extend those rather than creating parallel implementations.
- Prefer explicit over implicit — clear variable names, obvious control flow.

## Working with Unfamiliar APIs

- If you are not confident about an API's signatures, configuration format, or conventions, read the actual source code or documentation BEFORE writing any code. Do not guess.
- When working with Neovim plugins, Rust crates, or any domain-specific library, list the relevant API functions and their expected arguments before proposing changes.

## Debugging & Problem Solving

- When debugging or fixing issues, NEVER try quick-fix guesses (disabling features, swapping configs, trial-and-error). Instead:
  1. Reproduce or confirm the exact problem
  2. Read the relevant source code and logs
  3. State your hypothesis about the root cause
  4. Wait for my confirmation before implementing any fix
- If your first approach doesn't work, do NOT retry the same strategy with minor variations. Stop, reassess, and propose a fundamentally different approach or ask for clarification.

## Testing & Validation

- **CRITICAL: NEVER run tests without first reading the project's testing documentation.**
- Testing procedures vary by repository and improper execution can destroy production data.
- Always search for testing instructions in README files (root, test dir, docs, .github).
- When creating or modifying tests, strictly follow the existing test structure and framework used in that specific repository.
- If testing documentation is unclear or missing, ask before proceeding.
- For bug fixes, consider if a test should be added to prevent regression, but only after understanding the testing framework.
- **A trivial passing test is worse than a failing real test** — never weaken tests to make them pass.
- Do not change assertions to test obvious truths or remove the actual conditions being tested.
- Do not mock out the real functionality being tested unless that was the original test design.
- If a test won't pass after multiple legitimate attempts, stop and explain the problem — describe what you've tried, why it failed, and ask for direction.
- Preserving test validity is more important than having all tests pass.

## After Making Changes

- After each logical change (not batched at the end), run the relevant compiler/linter/test checks:
  - Rust: `cargo check` or `cargo test` after edits to `.rs` files
  - JavaScript/TypeScript: run the project's lint and test commands
- If any check fails, fix it immediately before moving to the next change.
- When generating test files, verify import paths are correct relative to the test file's location. Double-check mock data shapes against the actual schema.

## Git & Commits

- `git commit` every individual file you edit/create in an isolated commit. The commit message must follow the conventional commit style (e.g. `feat: add user login`), with a subject line no longer than 50 characters, and must include a body with detailed explanation of the changes and justification.
  - If you are unable to `git commit`, provide the commit message as a multi-line comment at the very top of the file.
- Keep commits small and focused — if a change involves multiple unrelated fixes, split into separate commits.
- NEVER use `git push`, `git push --force`, or `git push --force-with-lease` — stop and ask the user if force push looks like the only viable route.

## Code Quality

- Write code that is easily understandable, efficient, maintainable, modular, and above all, follows the conventions of the rest of the code in the project.
- Handle errors appropriately for the context (don't just add try-catch everywhere).
- Consider edge cases, but don't over-engineer for hypothetical scenarios. Prefer clarity over cleverness.
- Remove debug code (console.log, print statements, commented code) before committing.
- Write helpful error messages that aid debugging — include context about what failed and why.
- For APIs or shared interfaces, consider backwards compatibility before making breaking changes, unless instructed otherwise.
