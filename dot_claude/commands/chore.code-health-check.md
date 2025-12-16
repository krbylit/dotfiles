---
description: Comprehensive codebase health survey identifying dead code, outdated implementations, and simplification opportunities
allowed-tools: Read, Grep, Glob, Task, Bash
argument-hint: "[--scope=full|module|file|branch|commit|diff] [--base-branch <branch>] [--focus=dead-code|outdated|complexity|all] [--implement]"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command performs a comprehensive "health check" of the codebase by studying code in the context of current project goals, identifying vestiges of old implementations, finding unused/dead code, and suggesting simplification opportunities. **By default, it ONLY identifies and suggests changes** - it will not implement anything unless the `--implement` flag is provided and user approves each change.

### Execution Steps

1. **Parse Arguments**:

   **Scope flags**:
   - `--scope=full` (entire codebase, default)
   - `--scope=module <path>` (specific module/directory)
   - `--scope=file <path>` (single file)
   - `--scope=branch` (files changed in current branch vs base branch)
   - `--scope=commit <sha>` (files changed in a specific commit)
   - `--scope=diff <sha1>..<sha2>` (files changed between two commits)

   **Git scope options**:
   - `--base-branch <branch>` (specify base branch for `--scope=branch`, otherwise auto-detect)

   **Focus flags**:
   - `--focus=dead-code` (only find unused code)
   - `--focus=outdated` (only find vestiges of old implementations)
   - `--focus=complexity` (only find simplification opportunities)
   - `--focus=brute-force` (only find brute-force implementations needing abstraction)
   - `--focus=all` (all categories, default)

   **Action flags**:
   - `--implement` (after approval, implement suggested changes)
   - `--report-only` (default, only generate report)

2. **Intelligent Base Branch Detection** (for `--scope=branch` without `--base-branch`):

   If `--scope=branch` is specified but `--base-branch` was NOT provided, auto-detect base branch:

   a. **Check which standard branches exist**:

   ```bash
   # Check local and remote branches
   git branch --all | grep -E '(develop|main|master)$'
   ```

   b. **Find merge-base with each candidate**:

   ```bash
   # For develop (if exists)
   merge_base_develop=$(git merge-base HEAD develop 2>/dev/null)

   # For main (if exists)
   merge_base_main=$(git merge-base HEAD main 2>/dev/null)

   # For master (if exists)
   merge_base_master=$(git merge-base HEAD master 2>/dev/null)
   ```

   c. **Determine which merge-base is most recent**:

   ```bash
   # Get timestamp of each merge-base and compare
   # Select the branch with the newest merge-base

   if [ -n "$merge_base_develop" ]; then
     timestamp_develop=$(git show -s --format=%ct $merge_base_develop)
   fi

   if [ -n "$merge_base_main" ]; then
     timestamp_main=$(git show -s --format=%ct $merge_base_main)
   fi

   if [ -n "$merge_base_master" ]; then
     timestamp_master=$(git show -s --format=%ct $merge_base_master)
   fi
   ```

   d. **Select base branch** (priority order):
   1. `develop` (if merge-base exists and is most recent)
   2. `main` (if merge-base exists and is most recent, or if develop doesn't exist)
   3. `master` (if merge-base exists and is most recent, or if develop/main don't exist)

   e. **Validation**:
   - If detected base branch is NOT one of: develop, main, master
   - ERROR: "Cannot auto-detect base branch. Please specify with --base-branch <branch>"

   f. **Report detected base branch**:

   ```
   🔍 Analyzing health of branch changes against: [branch-name]
   📍 Merge-base: [short-sha] ([relative-date])
   ```

3. **Gather Git-Scoped Files** (for git scope flags):

   Based on the git scope, collect the list of files to analyze:

   **For `--scope=branch`**:

   ```bash
   # Get files changed in current branch vs base
   git diff --name-only <base-branch>...HEAD
   ```

   **For `--scope=commit <sha>`**:

   ```bash
   # Get files changed in specific commit
   git show --name-only --format='' <sha>
   ```

   **For `--scope=diff <sha1>..<sha2>`**:

   ```bash
   # Get files changed between two commits
   git diff --name-only <sha1>..<sha2>
   ```

   **Expand to Related Files**:

   For each changed file, also consider analyzing:
   - Files that import/depend on the changed file
   - Files that the changed file imports/depends on
   - Test files corresponding to changed source files
   - Configuration files if source files reference them

   Use Grep to find imports/references:

   ```bash
   # Find files that import a changed module (example for Python)
   rg "from <module> import|import <module>" --files-with-matches

   # Find files that import a changed module (example for JavaScript/TypeScript)
   rg "import.*from ['\"].*<module>|require\(['\"].*<module>" --files-with-matches
   ```

   **Report scope**:

   ```
   📁 Files changed: [count]
   📁 Related files included: [count]
   📁 Total files to analyze: [count]
   ```

4. **Gather Project Context**:

   **This is critical for intelligent analysis**:

   a. **Read project documentation**:
   - `CLAUDE.md` - Current architecture, patterns, goals
   - `README.md` - Project overview, features
   - `IMPLEMENTATION_PLAN.md` or `TODO.md` - Current goals and roadmap
   - `CHANGELOG.md` - Recent changes, deprecated features
   - `REFACTORING_PLAN.md` - Known technical debt
   - `.specify/*` - Specs and tasks for current and previous goals

   b. **Understand current state**:
   - What features are actively being developed?
   - What architecture patterns are currently used?
   - What are the stated project goals?
   - What has recently been deprecated or removed?

   c. **Git history analysis**:
   - `git log --since="3 months ago" --oneline` - Recent commits
   - `git log --all --grep="deprecated\|remove\|delete" --oneline` - Deprecation history
   - Identify major refactorings or architecture changes

   **Why this matters**: Code that looks "unused" might actually be:
   - Part of a planned feature (mentioned in TODO.md)
   - Required for a deprecated-but-not-removed API
   - Temporarily unused during refactoring

   Context prevents false positives.

5. **Dead Code Detection**:

   **Strategy**: Find code that is defined but never used

   a. **Collect all definitions**:
   - Functions, methods, structs, enums, traits, constants, types
   - Use language-appropriate tools:
     - Rust: `cargo +nightly rustc -- -Z print-type-sizes` or manual Grep
     - TypeScript/JavaScript: Parse imports/exports
     - Python: Parse function/class definitions
   - Build a registry of all defined symbols

   b. **Collect all references**:
   - For each symbol, search codebase for usages
   - Use Grep with appropriate patterns
   - Consider:
     - Direct calls/references
     - Trait implementations (Rust)
     - Dynamic dispatch (may hide usage)
     - FFI boundaries
     - Test code usage
     - Macro-generated code

   c. **Analyze usage**:
   - Symbol with ZERO references → Likely dead code
   - Symbol used ONLY in tests → Test-only code (note, might be intentional)
   - Symbol used ONLY in deprecated code → Transitively dead
   - Symbol used in commented-out code → Dead

   d. **Filter false positives**:
   - **Public API**: Even if unused internally, might be used by external consumers
   - **Entry points**: main(), lib exports, FFI exports
   - **Trait implementations**: Required by trait even if not directly called
   - **Future work**: Mentioned in TODO.md or IMPLEMENTATION_PLAN.md
   - **Configuration**: Used in config files or environment variables
   - **Test fixtures**: Deliberately unused except in tests

   e. **Categorize findings**:
   - **Definitely dead**: Zero references, not public API, not mentioned in plans
   - **Probably dead**: Only used in deprecated code or comments
   - **Test-only**: Only used in test code (may be intentional)
   - **Unclear**: Has references but seems like old implementation

6. **Outdated Code Detection**:

   **Strategy**: Find vestiges of old implementations that coexist with new ones

   a. **Identify patterns of old vs new**:
   - **Naming patterns**: `old_*`, `legacy_*`, `deprecated_*`, `v1_*` vs `v2_*`
   - **Module structure**: Old modules coexisting with new refactored ones
   - **Architectural patterns**: Old pattern implementation alongside new pattern
   - **Dependencies**: Old library version code alongside new library code

   b. **Look for duplicate functionality**:
   - Search for similar function names (e.g., `parse_person` and `parse_person_v2`)
   - Find multiple implementations of same concept (two cache layers, two parsers)
   - Use Grep to search for similar code patterns

   c. **Check for deprecation markers**:
   - `#[deprecated]` attributes (Rust)
   - `@deprecated` JSDoc tags (TypeScript/JavaScript)
   - `# deprecated` comments (Python)
   - TODO comments mentioning "remove", "delete", "replace", "migrate"

   d. **Analyze git history for refactoring**:
   - `git log --all --grep="refactor\|rewrite\|replace" --oneline`
   - Check if old code paths still exist after refactoring commits
   - Compare file structure before/after major refactors

   e. **Cross-reference with current architecture**:
   - Does this code follow patterns described in CLAUDE.md?
   - Is this code mentioned in current architecture docs?
   - Is this using deprecated dependencies?

   f. **Categorize findings**:
   - **Definitely outdated**: Deprecated markers + unused
   - **Probably outdated**: Similar to new implementation, not referenced
   - **Migration in progress**: Old and new coexist, plan exists to remove old
   - **Unclear**: Might be alternative implementation, not vestige

7. **Complexity & Simplification Opportunities**:

   **Strategy**: Find code that can be simplified without changing behavior

   a. **Identify complexity hotspots**:
   - Functions with high cyclomatic complexity (many branches)
   - Deep nesting (>4 levels)
   - Long functions (>100 lines)
   - Large modules (>1000 lines)
   - Duplicate code patterns

   b. **Analyze for simplification patterns**:

   **Pattern 1: Unnecessary abstraction**:
   - Single-method traits with one implementation
   - Wrapper types that add no value
   - Over-engineered generics

   **Pattern 2: Dead branches**:
   - Conditional logic that always evaluates same way
   - Error handling for errors that never occur
   - Feature flags that are always on/off

   **Pattern 3: Duplicate code**:
   - Copy-pasted logic (search for similar code blocks)
   - Could be extracted to shared function

   **Pattern 4: Outdated patterns**:
   - Using old idioms when language/library has better way
   - Manual implementations of now-standard library features

   **Pattern 5: Over-fetching**:
   - Reading entire files when only need subset
   - Fetching all records when only need count
   - Building full objects when only need one field

   **Pattern 6: Premature optimization**:
   - Complex caching for rarely-called functions
   - Over-engineered performance tricks with minimal gain
   - Unnecessary memory pooling

   c. **Check against project patterns**:
   - Does this follow conventions in CLAUDE.md?
   - Is there a simpler pattern used elsewhere for same problem?
   - Would simplification align with project direction?

   d. **Categorize findings**:
   - **High value**: Big complexity reduction, low refactoring cost
   - **Medium value**: Moderate improvement, moderate cost
   - **Low value**: Minor improvement or high refactoring cost
   - **Risky**: Simplification might break subtle behavior

8. **Brute Force / Abstraction Opportunity Detection**:

   **Strategy**: Identify implementations that could benefit from established patterns, abstractions, or idiomatic approaches to improve readability, maintainability, and extensibility.

   **IMPORTANT**: Prioritize analysis of Python, JavaScript, and Rust files.

   a. **Identify brute-force patterns**:

   **Pattern 1: Copy-paste duplication**:
   - Similar code blocks appearing 2+ times
   - Functions with near-identical structure but different specifics
   - Repeated error handling, validation, or transformation logic
   - Search for structurally similar code using Grep patterns

   **Pattern 2: Hard-coded values (magic numbers/strings)**:
   - Numeric literals without explanation (e.g., `if len > 1024`, `timeout = 30`)
   - String literals repeated across files (URLs, keys, messages)
   - Configuration embedded in logic instead of externalized
   - Grep for numeric literals: `[^0-9][0-9]{2,}[^0-9]` excluding obvious cases (0, 1, array indices)

   **Pattern 3: Verbose conditionals**:
   - Long if-else chains (5+ branches) that could be lookup tables/maps
   - Switch/match statements mapping values that could be data-driven
   - Type-checking cascades that could use polymorphism
   - Repeated null/undefined checks that could use Option/Result patterns

   **Pattern 4: Manual iteration anti-patterns**:
   - Loops that could be map/filter/reduce/fold
   - Manual index tracking when enumerate/zip available
   - Building results with mutation instead of functional transforms
   - Nested loops that could be flattened with itertools/combinators

   **Pattern 5: Tightly coupled code**:
   - Functions doing multiple unrelated things (violation of SRP)
   - Direct dependencies on concrete types instead of interfaces/traits
   - Business logic mixed with I/O, formatting, or infrastructure
   - God objects/modules that know too much

   **Pattern 6: Missing established patterns**:
   - State machines implemented as boolean flags
   - Observer pattern needed but using direct callbacks everywhere
   - Builder pattern needed for complex object construction
   - Strategy pattern needed for interchangeable algorithms
   - Factory pattern needed for object creation logic

   b. **Evaluate abstraction opportunities**:

   For each identified pattern, analyze:
   - **Readability impact**: Would abstraction make code clearer or more obscure?
   - **Maintainability impact**: How much easier would changes be?
   - **Extensibility impact**: Would new features be easier to add?
   - **Consistency**: Does similar code elsewhere use a better pattern?
   - **Language idioms**: Is there an idiomatic way to solve this in the language?

   c. **Consider when brute-force is appropriate**:

   **Mark as "Acceptable brute-force" when**:
   - **One-off scripts**: Code that runs once and won't be maintained
   - **Performance-critical paths**: Where abstraction overhead matters
   - **Prototype/experimental code**: Explicitly marked as temporary
   - **Simple cases**: Where abstraction would add more complexity than it removes
   - **Stability requirements**: Code that "just works" and rarely changes
   - **Team context**: When the simpler approach is more accessible to the team

   **Include trade-off notes** in the report for borderline cases.

   d. **Suggest specific improvements**:

   For each finding, provide:
   - **Current implementation**: Show the brute-force code
   - **Suggested pattern/abstraction**: Name the pattern and show example
   - **Benefits**: Specific improvements to readability/maintainability/extensibility
   - **Trade-offs**: Any downsides to the abstraction
   - **Implementation effort**: Low/Medium/High
   - **Similar code**: Other places in codebase that would benefit from same pattern

   e. **Categorize findings**:
   - **High impact**: Significantly improves maintainability, affects multiple files
   - **Medium impact**: Moderate improvement, localized to one module
   - **Low impact**: Minor improvement, nice-to-have
   - **Acceptable**: Brute-force is appropriate for this case (document why)

9. **Generate Comprehensive Report**:

   **Report structure**:

   ````markdown
   # Codebase Health Report

   **Generated**: [timestamp]
   **Scope**: [full/module/file/branch/commit/diff]
   **Base Branch**: [if git scope, show base branch or N/A]
   **Focus**: [all/dead-code/outdated/complexity]

   ## Executive Summary

   - **Total Issues Found**: [count]
   - **Dead Code**: [count] ([definitely/probably/test-only breakdown])
   - **Outdated Code**: [count] ([definitely/probably/unclear breakdown])
   - **Simplification Opportunities**: [count] ([high/medium/low value breakdown])
   - **Brute Force / Abstraction Opportunities**: [count] ([high/medium/low impact breakdown])
   - **Estimated Cleanup Impact**: [lines of code that could be removed/refactored]

   ---

   ## 1. Dead Code

   ### 1.1 Definitely Dead (High Confidence)

   #### [File:Line] [Symbol Name]

   **Type**: [Function/Struct/Module]
   **Defined**: `[file path:line]`
   **References**: 0 (no usages found)
   **Public API**: No
   **Mentioned in plans**: No

   **Reason**: This [type] is defined but never called anywhere in the codebase. It's not part of the public API and not mentioned in TODO.md or IMPLEMENTATION_PLAN.md.

   **Recommendation**: Safe to delete.

   **Risk**: Low - no references found.

   ---

   #### [Symbol Name]

   ...

   ### 1.2 Probably Dead (Medium Confidence)

   #### [Symbol Name]

   **Type**: [Function/Struct]
   **Defined**: `[file path:line]`
   **References**: 2 (both in deprecated code)
   **Used in**: `deprecated_module.rs:45`, `deprecated_module.rs:78`

   **Reason**: Only used in `deprecated_module.rs` which is marked for removal.

   **Recommendation**: Delete when `deprecated_module.rs` is removed.

   **Risk**: Low - transitively dead via deprecated caller.

   ---

   ### 1.3 Test-Only Code

   #### [Symbol Name]

   **Type**: Function
   **Defined**: `[file path:line]`
   **References**: 5 (all in tests)

   **Reason**: Only used in test fixtures.

   **Recommendation**: Consider if this is intentional test infrastructure or leftover test data.

   **Risk**: Medium - might be intentional test utility.

   ---

   ## 2. Outdated Code

   ### 2.1 Definitely Outdated (High Confidence)

   #### [File/Module Name]

   **Type**: [Module/Function/Struct]
   **Location**: `[file path]`
   **Deprecated marker**: Yes (`#[deprecated]` at line X)
   **Replacement exists**: Yes (`new_implementation.rs`)
   **Still referenced**: No

   **Reason**: Marked as deprecated, has modern replacement in `new_implementation.rs`, and is no longer referenced anywhere.

   **Recommendation**: Safe to delete entire module.

   **Risk**: Low - explicitly deprecated and unused.

   ---

   ### 2.2 Probably Outdated (Medium Confidence)

   #### [Module Name] vs [New Module Name]

   **Old**: `src/old_cache/`
   **New**: `src/cache/`
   **Pattern**: Old uses manual HashMap, new uses Moka

   **Reason**: Codebase was refactored to use Moka caching (see commit abc123f "refactor: migrate to Moka cache"). Old cache implementation still exists but is not imported anywhere.

   **Recommendation**: Delete `src/old_cache/` directory.

   **Risk**: Medium - no references found, but wasn't explicitly marked deprecated.

   ---

   ## 3. Simplification Opportunities

   ### 3.1 High Value

   #### [Function Name]: Extract duplicate code

   **Location**: `[file path:line1]`, `[file path:line2]`, `[file path:line3]`
   **Pattern**: Similar error handling logic duplicated in 15 places
   **Complexity reduction**: ~200 lines → ~20 lines

   **Current**:

   ```rust
   // Repeated in 15 functions
   match result {
       Ok(val) => Ok(val),
       Err(e) => {
           tracing::error!("Operation failed: {}", e);
           Err(AppError::from(e))
       }
   }
   ```
   ````

   **Suggested**:

   ```rust
   // Extract to utility function
   fn handle_result<T, E>(result: Result<T, E>) -> Result<T, AppError>
   where E: Into<AppError> + Display
   {
       result.map_err(|e| {
           tracing::error!("Operation failed: {}", e);
           e.into()
       })
   }

   // Usage
   handle_result(result)
   ```

   **Benefit**: Eliminates duplication, ensures consistent error handling, reduces maintenance burden.

   **Risk**: Low - behavior-preserving refactor.

   ***

   #### [Function Name]: Reduce nesting

   **Location**: `[file path:function]`
   **Current complexity**: 5 levels of nesting, cyclomatic complexity = 15
   **Potential reduction**: 2 levels, complexity = 8

   **Reason**: Uses nested if-else chains. Can be flattened with early returns.

   **Benefit**: Improved readability, easier to understand control flow.

   **Risk**: Low - guard clauses are behavior-preserving.

   ***

   ### 3.2 Medium Value

   [Similar structure for medium-value items]

   ### 3.3 Low Value

   [Similar structure for low-value items]

   ***

   ## 4. Brute Force / Abstraction Opportunities

   ### 4.1 High Impact

   #### [File:Function] - [Pattern Name]

   **Type**: [Copy-paste duplication / Hard-coded values / Verbose conditionals / Manual iteration / Tight coupling / Missing pattern]
   **Location**: `[file path:line]`
   **Language**: [Python / JavaScript / Rust]

   **Current implementation**:

   ```python
   # Example: Verbose conditional that could be a lookup table
   def get_status_message(code):
       if code == 200:
           return "OK"
       elif code == 201:
           return "Created"
       elif code == 400:
           return "Bad Request"
       elif code == 401:
           return "Unauthorized"
       elif code == 403:
           return "Forbidden"
       elif code == 404:
           return "Not Found"
       elif code == 500:
           return "Internal Server Error"
       else:
           return "Unknown"
   ```

   **Suggested pattern**: Lookup table / Dictionary mapping

   ```python
   STATUS_MESSAGES = {
       200: "OK",
       201: "Created",
       400: "Bad Request",
       401: "Unauthorized",
       403: "Forbidden",
       404: "Not Found",
       500: "Internal Server Error",
   }

   def get_status_message(code):
       return STATUS_MESSAGES.get(code, "Unknown")
   ```

   **Benefits**:
   - **Readability**: Data is separated from logic, easier to scan
   - **Maintainability**: Adding new codes requires only one line change
   - **Extensibility**: Could easily load from config file or database

   **Trade-offs**: None significant for this case.

   **Implementation effort**: Low

   **Similar code**: Found in `src/api/responses.py:45`, `src/handlers/errors.js:23`

   ***

   ### 4.2 Medium Impact

   #### [File:Function] - Missing Builder Pattern

   **Type**: Missing established pattern
   **Location**: `[file path:line]`
   **Language**: Rust

   **Current implementation**:

   ```rust
   // Complex object construction with many optional fields
   let config = Config {
       host: args.host.unwrap_or("localhost".to_string()),
       port: args.port.unwrap_or(8080),
       timeout: args.timeout.unwrap_or(30),
       retries: args.retries.unwrap_or(3),
       // ... 10 more fields
   };
   ```

   **Suggested pattern**: Builder pattern

   ```rust
   let config = ConfigBuilder::new()
       .host(args.host.unwrap_or("localhost"))
       .port(args.port.unwrap_or(8080))
       .timeout(args.timeout.unwrap_or(30))
       .retries(args.retries.unwrap_or(3))
       .build()?;
   ```

   **Benefits**:
   - **Readability**: Fluent API, clear what each value represents
   - **Maintainability**: Validation in one place, defaults in builder
   - **Extensibility**: New fields don't break existing call sites

   **Trade-offs**: More boilerplate code for the builder itself.

   **Implementation effort**: Medium

   ***

   ### 4.3 Low Impact

   [Similar structure for low-impact items]

   ### 4.4 Acceptable Brute Force

   #### [File:Function] - Hard-coded retry count

   **Type**: Hard-coded values
   **Location**: `[file path:line]`

   **Current implementation**:

   ```javascript
   for (let i = 0; i < 3; i++) { ... }
   ```

   **Why acceptable**: This is a simple retry loop in a one-off migration script (`scripts/migrate_once.js`). The script will be deleted after migration. Extracting to a constant would add complexity without benefit.

   ***

   ***

   ## 5. Summary of Recommendations

   ### Immediate Actions (High Confidence, Low Risk)

   1. **Delete dead code** (15 items):
      - `src/old_parser.rs` (unused since refactor)
      - `PersonService::legacy_format()` (zero references)
      - [etc.]

   2. **Remove outdated modules** (5 items):
      - `src/old_cache/` (replaced by Moka implementation)
      - [etc.]

   3. **High-value simplifications** (8 items):
      - Extract duplicate error handling (15 occurrences)
      - [etc.]

   4. **High-impact abstraction opportunities** (6 items):
      - Replace verbose conditionals with lookup tables (3 occurrences)
      - Implement Builder pattern for Config construction
      - [etc.]

   ### Review Required (Medium Confidence)

   1. **Verify test-only code** (10 items):
      - Confirm these are intentional test fixtures

   2. **Validate outdated code** (7 items):
      - Double-check these aren't alternative implementations

   ### Future Consideration (Lower Priority)

   1. **Medium/low-value simplifications** (20 items)

   ***

   ## 6. Next Steps

   **If you approve these changes, run**:

   ```bash
   /codebase-health --implement
   ```

   This will:
   1. Show you each recommended change
   2. Ask for approval before implementing
   3. Create atomic commits for each change category
   4. Generate a summary of all changes made

   **Or selectively implement**:

   ```bash
   /codebase-health --implement --focus=dead-code
   ```

   ```

   ```

10. **Interactive Implementation** (if --implement flag provided):

   **IMPORTANT**: Do NOT implement anything without explicit user approval for each change.

   a. **Group changes by category**:

- Group 1: Dead code deletion (high confidence)
- Group 2: Outdated code removal (high confidence)
- Group 3: High-value simplifications
- Group 4: High-impact abstraction opportunities
- Group 5: Medium-value simplifications and abstractions
- Group 6: Everything else

   b. **For each group**:

   i. **Present summary**:

   ````
   Group: Dead Code Deletion (High Confidence)
   Items: 15
   Files affected: 8
   Lines removed: ~500

         Items:
         1. src/old_parser.rs (entire file, 120 lines)
         2. src/domain/person_service.rs:legacy_format() (35 lines)
         ...

         Approve deletion of these 15 items? [y/N/show]
         ```

   ii. **Handle user response**: - `y` or `yes`: Proceed with deletion - `n` or `no`: Skip this group - `show`: Show detailed diff for each item, allow individual approval - `show N`: Show detailed diff for item N only

   iii. **Implement approved changes**:
       - Delete dead code files/functions
       - Remove outdated modules
       - Refactor complex code
       - Run tests after each change to verify no breakage
       - If tests fail, STOP and report error, don't continue

   iv. **Create atomic commit**:

       **IMPORTANT**: Read `~/.claude/commands/commit-atomic.md` to understand the
       commit message quality guidelines.

       Apply those same standards here, with these specifics:
       - **Type determination**:
         - Dead code deletion → `refactor:` or `chore:`
         - Outdated code removal → `refactor:`
         - Simplification → `refactor:`
         - Abstraction/pattern implementation → `refactor:`
       - **Scope**: The area affected (e.g., `domain`, `api`, or specific module)
       - **Subject examples**:
         - `refactor: remove dead code from person service`
         - `refactor: remove outdated cache implementation`
         - `refactor: extract duplicate error handling`
         - `refactor: replace conditionals with lookup table`
         - `refactor: implement builder pattern for Config`
       - **Body**: IMPORTANT - include list of deleted/changed items with brief context
       - **Validation**: Use the same validation checklist from commit-atomic.md

   c. **After all groups processed**:
   - Run full test suite
   - Generate summary report of what was changed
   - Suggest next steps (e.g., "run linter", "update documentation")

   ````

1. **Validation**:

   **For git scope flags** (branch/commit/diff):

- [ ] Git repository verified
- [ ] Base branch detected or specified (for --scope=branch)
- [ ] Commit SHA(s) validated (for --scope=commit or --scope=diff)
- [ ] Files to analyze collected successfully
- [ ] Related/dependent files identified and included
- [ ] Binary and deleted files excluded
- [ ] Report clearly indicates git scope and limitations

   **Before generating report**:

- [ ] Project context gathered (CLAUDE.md, README, TODO, git history)
- [ ] Dead code analysis filtered false positives (public API, entry points, trait impls)
- [ ] Outdated code cross-referenced with current architecture
- [ ] Simplification suggestions are behavior-preserving
- [ ] Brute-force analysis prioritized Python/JavaScript/Rust over shell scripts
- [ ] Abstraction suggestions include trade-off analysis
- [ ] "Acceptable brute-force" cases documented with justification
- [ ] All findings include file paths and line numbers
- [ ] Confidence/impact levels assigned (high/medium/low)
- [ ] Risk levels assigned (low/medium/high)
- [ ] Recommendations are actionable

   **Before implementing** (if --implement):

- [ ] User approved changes
- [ ] Tests pass before changes
- [ ] Each change implemented correctly
- [ ] Tests pass after each change
- [ ] Atomic commits created with good messages

## Detection Strategies by Language

### Rust

**Dead code detection**:

- `cargo +nightly rustc -- -Wdead_code` (compiler warnings)
- Grep for function definitions: `pub fn \w+|fn \w+`
- Grep for struct definitions: `pub struct \w+|struct \w+`
- Cross-reference with usage via Grep

**Outdated code**:

- Look for `#[deprecated]` attributes
- Search for `_v1`, `_old`, `_legacy` suffixes
- Check Cargo.toml for deprecated dependencies

**Complexity**:

- Use `cargo clippy -- -W clippy::cognitive_complexity`
- Search for deep nesting (manual inspection or regex)

**Brute-force / Abstraction opportunities**:

- Look for long `match` statements that could be HashMaps/lookup tables
- Search for repeated `.unwrap_or()` chains suggesting Builder pattern
- Find manual `for` loops that could be iterator combinators (`map`, `filter`, `fold`)
- Detect structs with many fields (>5) without Builder
- Search for `if let Some...else if let Some` chains suggesting pattern matching improvements
- Look for functions with many boolean parameters suggesting use of structs or enums
- Find repeated error handling code that could use a custom error type or `?` operator
- Grep for magic numbers: `[^0-9_][0-9]{2,}[^0-9_]` (excluding array indices and common constants)

### TypeScript/JavaScript

**Dead code detection**:

- Parse imports/exports
- Use TSC with `--noUnusedLocals` and `--noUnusedParameters`
- Grep for function definitions: `function \w+|const \w+ =|export function`

**Outdated code**:

- Look for `@deprecated` JSDoc tags
- Search for old patterns (e.g., `var` vs `const/let`)
- Check package.json for deprecated packages

**Complexity**:

- Use ESLint complexity rules
- Check for callback hell vs async/await

**Brute-force / Abstraction opportunities**:

- Look for long `switch` statements or `if-else` chains → suggest object lookup or Map
- Search for repeated `if (x !== null && x !== undefined)` → suggest optional chaining (`?.`)
- Find manual array manipulation (`for`, `push`) → suggest `map`, `filter`, `reduce`
- Detect callback-heavy code → suggest async/await or Promise.all
- Look for string concatenation with `+` in loops → suggest template literals or array join
- Search for repeated type checking (`typeof x === 'string'`) → suggest TypeScript or discriminated unions
- Find objects constructed with many inline properties → suggest factory function or class
- Grep for magic numbers/strings repeated across files
- Look for duplicate fetch/API call patterns → suggest centralized API client

### Python

**Dead code detection**:

- Use `vulture` tool for dead code detection
- Grep for function/class definitions: `def \w+|class \w+`

**Outdated code**:

- Search for Python 2 patterns (print statements, old string formatting)
- Check requirements.txt for deprecated packages

**Complexity**:

- Use `radon` for cyclomatic complexity
- Use `pylint` for complexity warnings

**Brute-force / Abstraction opportunities**:

- Look for long `if-elif-elif` chains → suggest dictionary dispatch or match statement (3.10+)
- Search for repeated `for` loops → suggest list/dict/set comprehensions or generator expressions
- Find manual iteration with index → suggest `enumerate()`, `zip()`, or itertools
- Detect `try-except` blocks with identical handling → suggest context managers or decorators
- Look for functions with many positional arguments → suggest dataclasses, NamedTuple, or kwargs
- Search for repeated string formatting → suggest f-strings or Template
- Find hardcoded config values → suggest environment variables, config files, or constants module
- Look for repeated file/network I/O patterns → suggest context managers or utility functions
- Search for class methods that don't use `self` → suggest `@staticmethod` or module-level function
- Detect repeated validation logic → suggest Pydantic models or custom validators

## Edge Cases & Error Handling

**Large codebases (>100 files)**:

- Warn user this may take several minutes
- Consider using `--scope=module` for faster analysis
- Use parallel Grep searches where possible

**Monorepos with multiple projects**:

- Analyze each project separately
- Note cross-project dependencies
- Recommend scoping to specific project

**Generated code**:

- Detect generated code directories (e.g., `target/`, `node_modules/`, `generated/`)
- Exclude from analysis
- Note in report: "Excluded N generated files"

**Dynamic languages (Python, JavaScript)**:

- Note that static analysis may miss dynamic usage
- Lower confidence in dead code detection
- Recommend runtime profiling for confirmation

**Public API concerns**:

- If crate is published (Cargo.toml has `publish = true`), be very conservative
- Mark all pub items as "possible public API, cannot determine if used externally"
- Suggest user verify if external usage exists

**Test failures during implementation**:

- STOP immediately if tests fail
- Report which change broke tests
- Offer to revert that change
- Do NOT continue with remaining changes

**Unclear context**:

- If CLAUDE.md or TODO.md missing, note lack of context
- Lower confidence in all findings
- Recommend creating project documentation first

**Git scope edge cases**:

**Not in a git repository**:

- ERROR: "Not a git repository. Git scope flags require a git repository."
- Suggest using `--scope=full`, `--scope=module`, or `--scope=file` instead

**On base branch (for `--scope=branch`)**:

- If current branch is develop/main/master
- ERROR: "Cannot analyze branch changes when on base branch. Switch to a feature branch or use `--scope=full`."

**No commits ahead of base (for `--scope=branch`)**:

- If `git rev-list --count <base>..HEAD` returns 0
- ERROR: "No commits ahead of base branch. Make some changes first or use `--scope=full`."

**Invalid commit SHA**:

- If specified commit doesn't exist
- ERROR: "Commit [sha] not found. Verify the commit SHA is correct."

**Invalid commit range syntax**:

- If diff argument doesn't match `<sha>..<sha>` pattern
- ERROR: "Invalid commit range format. Use `--scope=diff <sha1>..<sha2>`"

**Detached HEAD (for `--scope=branch`)**:

- If on detached HEAD
- ERROR: "Cannot determine branch for detached HEAD. Use `--scope=commit <sha>` or `--scope=diff <sha1>..<sha2>` instead."

**No files changed in git scope**:

- If git diff returns no files
- INFO: "No files changed in specified git scope. Nothing to analyze."

**Binary files in git scope**:

- Skip binary files from analysis
- Note in report: "Skipped N binary files"

**Deleted files in git scope**:

- Skip deleted files (they no longer exist to analyze)
- Note in report: "Skipped N deleted files"

**Renamed files in git scope**:

- Analyze renamed files using their new paths
- Note in report if rename detection affected analysis

## Examples

### Example 1: Full codebase health check

**Command**: `/codebase-health`

**Output**: (Generates comprehensive report as shown in step 6 above)

### Example 2: Focus on dead code in specific module

**Command**: `/codebase-health --scope=module src/domain --focus=dead-code`

**Output**:

````markdown
# Codebase Health Report

**Generated**: 2025-02-15 14:30:00
**Scope**: Module (src/domain)
**Focus**: Dead Code Only

## Executive Summary

- **Total Dead Code Items**: 8
- **Definitely Dead**: 5
- **Probably Dead**: 2
- **Test-Only**: 1
- **Estimated Cleanup**: 320 lines of code

---

## Dead Code

### Definitely Dead (High Confidence)

#### src/domain/person_service.rs:245 - `legacy_person_format()`

**Type**: Function
**Defined**: `src/domain/person_service.rs:245`
**References**: 0
**Public API**: No (private function)

**Reason**: This function was used to format person data in the old API v1 format. API v1 was removed in commit abc123f ("feat: remove API v1 endpoints"). Function still exists but is never called.

**Recommendation**: Safe to delete.

**Risk**: Low - zero references.

---

[Additional items...]

## Next Steps

To delete these 5 items, run:

```bash
/codebase-health --scope=module src/domain --focus=dead-code --implement
```
````

```

### Example 3: Implementation workflow

**Command**: `/codebase-health --focus=dead-code --implement`

**Output**:
```

Analyzing codebase for dead code...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Found 15 definitely dead code items.

Group: Dead Code Deletion (High Confidence)
Items: 15
Files affected: 8
Lines to remove: ~487

Items:

1. src/old_parser.rs (entire file, 120 lines)
2. src/domain/person_service.rs:legacy_format() (35 lines)
3. src/domain/person_service.rs:format_v1() (28 lines)
4. src/api/handlers/legacy.rs (entire file, 145 lines)
5. src/utils/old_validation.rs (entire file, 89 lines)
   ... (10 more items)

Approve deletion of all 15 items? [y/N/show]:

```

**User types**: `show 1`

```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Item 1: src/old_parser.rs

## File contents (120 lines)

## [Shows file contents]

This file was used for parsing API v1 requests. API v1 was removed in commit abc123f.

No references found in codebase.

Approve deletion of src/old_parser.rs? [y/N]:

```

**User types**: `y`

```

✅ Deleted src/old_parser.rs (120 lines removed)

Approve deletion of remaining 14 items? [y/N/show]:

```

**User types**: `y`

```

✅ Deleted src/domain/person_service.rs:legacy_format() (35 lines)
✅ Deleted src/domain/person_service.rs:format_v1() (28 lines)
✅ Deleted src/api/handlers/legacy.rs (145 lines)
... (continues for all items)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Running tests to verify changes...

test result: ok. 142 passed; 0 failed; 0 ignored

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Creating commit...

✅ Committed: refactor: remove dead code from domain and API layers

Removed 15 unused functions and modules (487 lines):

- src/old_parser.rs (API v1 parser, unused since v1 removal)
- src/domain/person_service.rs:legacy_format() (v1 formatting)
- ... (full list in commit body)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Cleanup complete!

Summary:

- 15 items deleted
- 487 lines removed
- 8 files modified
- All tests passing

Next steps:

- Review commit: git show HEAD
- Run linter: cargo clippy
- Update documentation if needed

`````

### Example 4: Focus on brute-force patterns

**Command**: `/codebase-health --focus=brute-force`

**Output**:

````markdown
# Codebase Health Report

**Generated**: 2025-02-15 14:30:00
**Scope**: Full
**Focus**: Brute Force / Abstraction Opportunities Only

## Executive Summary

- **Total Brute Force Issues**: 12
- **High Impact**: 4
- **Medium Impact**: 5
- **Low Impact**: 2
- **Acceptable (documented)**: 1
- **Languages analyzed**: Python (8 files), JavaScript (12 files), Rust (5 files)
- **Shell/Fish files skipped**: 23 (lower priority)

---

## Brute Force / Abstraction Opportunities

### High Impact

#### src/api/handlers.py:45 - Verbose Conditionals

**Type**: Verbose conditionals → Lookup table
**Location**: `src/api/handlers.py:45-78`
**Language**: Python

**Current implementation**:

```python
def get_error_response(code):
    if code == "E001":
        return {"status": 400, "message": "Invalid input"}
    elif code == "E002":
        return {"status": 401, "message": "Unauthorized"}
    elif code == "E003":
        return {"status": 403, "message": "Forbidden"}
    # ... 15 more cases
`````

**Suggested pattern**: Dictionary mapping

```python
ERROR_RESPONSES = {
    "E001": {"status": 400, "message": "Invalid input"},
    "E002": {"status": 401, "message": "Unauthorized"},
    "E003": {"status": 403, "message": "Forbidden"},
    # ... all cases as data
}

def get_error_response(code):
    return ERROR_RESPONSES.get(code, {"status": 500, "message": "Unknown error"})
```

**Benefits**:

- **Readability**: Error mappings visible at a glance
- **Maintainability**: Add/modify errors in one place
- **Extensibility**: Could load from config or localization file

**Trade-offs**: None significant.

**Implementation effort**: Low

**Similar code**: Also found in `src/utils/responses.js:23`, `src/cli/errors.rs:56`

---

#### src/services/user.js:120 - Manual Iteration

**Type**: Manual iteration → Functional approach
**Location**: `src/services/user.js:120-145`
**Language**: JavaScript

**Current implementation**:

```javascript
const results = [];
for (let i = 0; i < users.length; i++) {
  if (users[i].active) {
    const formatted = {
      id: users[i].id,
      name: users[i].firstName + " " + users[i].lastName,
      email: users[i].email.toLowerCase(),
    };
    results.push(formatted);
  }
}
return results;
```

**Suggested pattern**: Filter + Map

```javascript
return users
  .filter((user) => user.active)
  .map((user) => ({
    id: user.id,
    name: `${user.firstName} ${user.lastName}`,
    email: user.email.toLowerCase(),
  }));
```

**Benefits**:

- **Readability**: Declarative intent (filter active, then transform)
- **Maintainability**: Each operation isolated, easy to modify
- **Extensibility**: Easy to add more transformations in the chain

**Trade-offs**: Slight performance overhead for very large arrays (unlikely to matter).

**Implementation effort**: Low

---

### Acceptable Brute Force

#### scripts/migrate_v2.py:34 - Hard-coded timeout

**Type**: Hard-coded values
**Location**: `scripts/migrate_v2.py:34`

**Current implementation**:

```python
time.sleep(5)  # Wait for service to start
```

**Why acceptable**: This is a one-time migration script that will be deleted after the v2 migration is complete. The 5-second timeout is specific to this migration's requirements and extracting it would add unnecessary complexity.

---

## Next Steps

To implement these changes, run:

```bash
/codebase-health --focus=brute-force --implement
```

````

### Example 5: Branch health check (git scope)

**Command**: `/codebase-health --scope=branch`

**Output**:

````markdown
# Codebase Health Report

**Generated**: 2025-02-15 14:30:00
**Scope**: Branch (feature/add-caching)
**Base Branch**: main (auto-detected)
**Merge Base**: abc123f (3 days ago)
**Focus**: All Categories

## Files Analyzed

**Files changed in branch**: 8
**Related files included**: 12 (imports/dependencies)
**Total files analyzed**: 20

Changed files:
- src/services/person_service.rs
- src/services/cache.rs (new)
- src/api/handlers/persons.rs
- tests/person_service_test.rs
- Cargo.toml
- ...

---

## Executive Summary

- **Total Issues Found**: 6
- **Dead Code**: 1 (probably dead - old cache implementation)
- **Outdated Code**: 1 (deprecated function still used)
- **Simplification Opportunities**: 2 (medium value)
- **Brute Force / Abstraction**: 2 (high impact)

**Note**: Analysis limited to branch changes and related files. Run with `--scope=full` for comprehensive codebase analysis.

---

## Dead Code

### 1.1 Probably Dead (Medium Confidence)

#### src/services/person_service.rs:145 - `get_cached_person_old()`

**Type**: Function
**Defined**: `src/services/person_service.rs:145`
**References**: 0 in changed files, 1 in unchanged files

**Reason**: This function appears to be the old caching implementation. The new `cache.rs` module provides `get_cached_person()` which is being used in the new code. The old function is referenced in `src/legacy/compat.rs` which was not changed in this branch.

**Recommendation**: Verify if `src/legacy/compat.rs` still needs this function. If not, delete in a follow-up commit.

**Risk**: Medium - has reference in unchanged code, needs verification.

---

## Brute Force / Abstraction Opportunities

### High Impact

#### src/services/cache.rs:78 - Verbose Error Handling

**Type**: Copy-paste duplication
**Location**: `src/services/cache.rs:78-95`, `src/services/cache.rs:120-137`

**Current implementation**:

```rust
match cache.get(&key) {
    Ok(Some(value)) => Ok(value),
    Ok(None) => {
        let value = fetch_from_db(&key).await?;
        cache.insert(key.clone(), value.clone());
        Ok(value)
    }
    Err(e) => {
        tracing::error!("Cache error: {}", e);
        fetch_from_db(&key).await
    }
}
```

**Suggested pattern**: Extract to helper function

```rust
async fn cache_aside<T, F, Fut>(cache: &Cache, key: &str, fetch: F) -> Result<T>
where
    F: FnOnce() -> Fut,
    Fut: Future<Output = Result<T>>,
{
    // ... implementation
}
```

**Benefits**: Eliminates duplication in 3 places in this file, consistent error handling.

**Implementation effort**: Low

---

## Next Steps

To implement these changes on your branch, run:

```bash
/codebase-health --scope=branch --implement
```

Or check specific commit:

```bash
/codebase-health --scope=commit abc123f
```
````

### Example 6: Commit range health check

**Command**: `/codebase-health --scope=diff abc123f..def456g`

**Output**:

```
🔍 Analyzing health of changes between commits
📍 From: abc123f (refactor: extract cache service)
📍 To: def456g (feat: add cache invalidation)
📁 Files changed: 5
📁 Related files included: 8
📁 Total files to analyze: 13

[Generates report similar to branch scope, but limited to the commit range]
```

## Context

Additional user context: $ARGUMENTS

```
````
