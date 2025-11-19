---
description: Comprehensive codebase health survey identifying dead code, outdated implementations, and simplification opportunities
allowed-tools: Read, Grep, Glob, Task, Bash
argument-hint: "[--scope=full|module|file] [--focus=dead-code|outdated|complexity|all] [--implement]"
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

   **Focus flags**:
   - `--focus=dead-code` (only find unused code)
   - `--focus=outdated` (only find vestiges of old implementations)
   - `--focus=complexity` (only find simplification opportunities)
   - `--focus=all` (all categories, default)

   **Action flags**:
   - `--implement` (after approval, implement suggested changes)
   - `--report-only` (default, only generate report)

2. **Gather Project Context**:

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

3. **Dead Code Detection**:

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

4. **Outdated Code Detection**:

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

5. **Complexity & Simplification Opportunities**:

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

6. **Generate Comprehensive Report**:

   **Report structure**:

   ````markdown
   # Codebase Health Report

   **Generated**: [timestamp]
   **Scope**: [full/module/file]
   **Focus**: [all/dead-code/outdated/complexity]

   ## Executive Summary

   - **Total Issues Found**: [count]
   - **Dead Code**: [count] ([definitely/probably/test-only breakdown])
   - **Outdated Code**: [count] ([definitely/probably/unclear breakdown])
   - **Simplification Opportunities**: [count] ([high/medium/low value breakdown])
   - **Estimated Cleanup Impact**: [lines of code that could be removed]

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

   ## 4. Summary of Recommendations

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

   ### Review Required (Medium Confidence)

   1. **Verify test-only code** (10 items):
      - Confirm these are intentional test fixtures

   2. **Validate outdated code** (7 items):
      - Double-check these aren't alternative implementations

   ### Future Consideration (Lower Priority)

   1. **Medium/low-value simplifications** (20 items)

   ***

   ## 5. Next Steps

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

7. **Interactive Implementation** (if --implement flag provided):

   **IMPORTANT**: Do NOT implement anything without explicit user approval for each change.

   a. **Group changes by category**:
   - Group 1: Dead code deletion (high confidence)
   - Group 2: Outdated code removal (high confidence)
   - Group 3: High-value simplifications
   - Group 4: Medium-value simplifications
   - Group 5: Everything else

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
       - **Scope**: The area affected (e.g., `domain`, `api`, or specific module)
       - **Subject examples**:
         - `refactor: remove dead code from person service`
         - `refactor: remove outdated cache implementation`
         - `refactor: extract duplicate error handling`
       - **Body**: IMPORTANT - include list of deleted/changed items with brief context
       - **Validation**: Use the same validation checklist from commit-atomic.md

   c. **After all groups processed**:
   - Run full test suite
   - Generate summary report of what was changed
   - Suggest next steps (e.g., "run linter", "update documentation")

   ````

8. **Validation**:

   **Before generating report**:
   - [ ] Project context gathered (CLAUDE.md, README, TODO, git history)
   - [ ] Dead code analysis filtered false positives (public API, entry points, trait impls)
   - [ ] Outdated code cross-referenced with current architecture
   - [ ] Simplification suggestions are behavior-preserving
   - [ ] All findings include file paths and line numbers
   - [ ] Confidence levels assigned (high/medium/low)
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

```

## Context

Additional user context: $ARGUMENTS
```
