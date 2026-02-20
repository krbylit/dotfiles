---
name: record-determination
description: Capture and record a discovered constraint, requirement, design decision, or project invariant into the nearest CLAUDE.md. Use proactively when a conversation reveals something that should persist as a standing project rule — architectural choices, limitations, established conventions, gotchas, or requirements. Trigger on patterns like "we can't use X because", "always do Y", "we decided to", "the convention is", "never call Z", or any constraint/requirement that would affect future work on this project.
---

# Record Determination

You have identified (or a user has invoked this skill to capture) a determination that should persist as project guidance.

## Workflow

### 1. Identify & surface the determination

State clearly what was discovered or decided. If invoked proactively, surface it to the user:

> "This sounds like a project [constraint/decision/requirement] worth recording: [1-sentence summary]. Want me to add it to CLAUDE.md?"

If the user says no, stop. If yes, continue.

### 2. Collect rationale (strongly encouraged, not required)

If the rationale is not already clear from context, ask:

> "Any context or reasoning to include? (e.g., why this constraint exists, what it prevents, why this approach was chosen over alternatives)"

Rationale makes entries far more useful over time. If the user declines, proceed without it.

### 3. Draft the bullet

Write a single, succinct bullet that is self-contained and reads as a rule or fact — not a conversation artifact.

Format: `- <determination>[; <rationale/context>]`

**Bad** (conversation artifact):

- `- We said we shouldn't call foo() from tests`

**Good** (self-contained rule):

- `- Do not call foo() from tests; it bypasses the mock layer and causes real network requests`
- `- Use bun instead of npm; npm is not installed in CI`
- `- Chose Zustand for client state; lower boilerplate than Redux with no meaningful capability tradeoff at current scale`

Rules:

- Start with an imperative or declarative statement
- Use `;` to separate determination from rationale/context
- 1–2 lines maximum
- Specific enough to be actionable, not so specific it goes stale immediately
- No timestamps, no category tags

### 4. Determine target file

**Project-specific** (default): find the nearest `CLAUDE.md` by walking up from the current working directory.

**Global**: if the determination clearly applies across all projects (general toolchain preferences, personal workflow rules, AI assistant behavior unrelated to any single project), ask the user:

> "This sounds like it might apply globally, not just to this project. Record it in the project CLAUDE.md, or in the global one at `~/.claude/CLAUDE.md`?"

### 5. Check for duplicates and contradictions

Read the full `## Decisions & Constraints` section of the target file (if it exists).

- **Already covered**: tell the user and stop — do not write
- **Closely related to an existing point**: show both entries and ask: modify the existing entry, add a sub-bullet, or add as a separate entry?
- **Contradicts an existing point**: flag explicitly before writing anything:
  > "This contradicts an existing entry: `[existing bullet]`. How do you want to resolve this?"
  > Wait for user direction before proceeding.

### 6. Write to CLAUDE.md

- If `## Decisions & Constraints` section exists: append the bullet under it
- If it does not exist: create the section at the end of the file and add the bullet
- Do not commit — leave that to the user
