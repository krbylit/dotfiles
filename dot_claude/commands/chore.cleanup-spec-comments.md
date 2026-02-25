---
description: Clean up spec-kit style comment tags (FR-XXX, TS-XXX, US-XXX, T0XX) from code while preserving helpful comments, using a team of agents working in parallel
allowed-tools: Task, TeamCreate, TeamDelete, TaskCreate, TaskList, TaskUpdate, TaskGet, SendMessage, Grep, Bash
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This command spawns a team of agents to clean up development process comments (spec-kit style tags like FR-XXX, TS-XXX, US-XXX, T0XX) from code files in parallel while preserving helpful contextual comments.

### Team Structure

- **Team Lead**: Coordinates the work, creates tasks, monitors progress, does not edit files
- **3 Worker Agents**: Each agent claims tasks and cleans up files in parallel

### Execution Steps

#### Phase 1: Team Lead - Setup and Task Creation

1. **Create Team**:
   - Use TeamCreate to create a team named "comment-cleanup-team"
   - Team description: "Parallel cleanup of spec-kit comment tags from codebase"

2. **Identify Files to Clean**:
   - Use Grep to find all files containing spec-kit tags:

     ```
     # Search for tags with hyphens (FR-XXX, SC-XXX, TS-XXX)
     pattern: (FR|SC|TS)-\d+
     output_mode: files_with_matches
     ```

   - Then search for task numbers (TXXX - three digits, no hyphen):

     ```
     pattern: \bT\d{3}\b
     output_mode: files_with_matches
     ```

   - Then search for user stories (USX - no hyphen):

     ```
     pattern: \bUS\d+\b
     output_mode: files_with_matches
     ```

   - Combine results into unique list of files

3. **Create Tasks**:
   - For each file found, create a TaskCreate with:
     - **subject**: `Clean spec-kit tags from <filename>`
     - **description**: Full file path and instructions:

       ```
       File: <full-path>

       Remove all spec-kit style tags while preserving helpful comments.

       Tags to remove:
       - FR-XXX (Functional Requirements: FR-001 to FR-064)
       - SC-XXX (Success Criteria: SC-001 to SC-015)
       - TS-XXX (Technical Specs: TS-5, TS-9, etc.)
       - TXXX (Tasks: T001 to T084, three digits, no hyphen)
       - USX (User Stories: US1 to US7, no hyphen)

       Guidelines:
       - Remove comments that reference these tags
       - Keep comments that explain complex logic, architectural decisions, or important context
       - Keep comments that describe MongoDB aggregation stages, performance optimizations, error handling patterns
       - Do NOT remove helpful inline comments that explain the code
       - Do NOT modify test files (describe blocks can keep TXXX tags for test identification)
       - Verify file still has helpful comments after cleanup
       ```

     - **activeForm**: `Cleaning spec-kit tags from <filename>`

4. **Spawn Worker Agents**:
   - Use Task tool to spawn 3 worker agents (subagent_type: "implementer")
   - Each with name: "cleanup-worker-1", "cleanup-worker-2", "cleanup-worker-3"
   - Each with team_name: "comment-cleanup-team"
   - Each with prompt:

     ```
     You are a code cleanup specialist working on a team to remove development process comments.

     Your job:
     1. Check TaskList for available tasks (status: pending, no owner, no blockedBy)
     2. Claim a task using TaskUpdate (set owner to your name)
     3. Read the file specified in the task description
     4. Remove ALL spec-kit style tags from comments
     5. Preserve helpful comments that explain logic, architecture, or important context
     6. Use Edit tool to make changes
     7. Mark task as completed using TaskUpdate
     8. Repeat steps 1-7 until no tasks remain
     9. Send message to team-lead when you have no more work

     Tags to remove (exact patterns):
     - "FR-XXX:" (e.g., FR-001, FR-016, FR-042) - Functional Requirements
     - "SC-XXX:" (e.g., SC-001, SC-014) - Success Criteria
     - "TS-XXX:" (e.g., TS-5, TS-9) - Technical Specs
     - "TXXX:" (e.g., T001, T040, T051) - Task numbers (three digits, NO hyphen)
     - "USX:" (e.g., US1, US2) - User Stories (NO hyphen)

     Guidelines for what to remove:
     - Tag prefixes and any references to them on the same line
     - Entire comment lines that ONLY contain spec-kit tags
     - Multi-line comment blocks that reference spec-kit tags

     Guidelines for what to keep:
     - Comments explaining WHY (architectural decisions, tradeoffs)
     - Comments explaining HOW (algorithm steps, aggregation stages)
     - Comments about performance, security, error handling
     - Helpful inline comments about code behavior

     Work efficiently and claim your next task as soon as you complete one.
     ```

5. **Monitor Progress**:
   - Use TaskList periodically to check progress
   - Wait for messages from worker agents
   - When all agents report completion, verify all tasks are completed

6. **Cleanup and Report**:
   - Use TaskList to verify all tasks completed
   - Request shutdown of all worker agents using SendMessage with type: "shutdown_request"
   - Use TeamDelete to clean up team resources
   - Report summary:
     - Total files cleaned
     - Any issues encountered
     - Suggest next steps (git diff, commit, etc.)

#### Phase 2: Worker Agents - Parallel Cleanup

Each worker agent follows this loop:

1. **Check for Available Work**:
   - Call TaskList
   - Find tasks with status: pending, no owner, empty blockedBy
   - Prefer tasks in ID order (lowest first)

2. **Claim Task**:
   - Use TaskUpdate to set owner to your name
   - Use TaskUpdate to set status to "in_progress"

3. **Read Task Details**:
   - Use TaskGet to get full task description
   - Extract file path from description

4. **Read File**:
   - Use Read tool to read the entire file
   - Identify all spec-kit tags (FR-XXX, SC-XXX, TS-XXX, TXXX, USX)

5. **Clean Up Comments**:
   - For each occurrence, use Edit tool to remove the spec-kit tag
   - Preserve the helpful part of the comment if any
   - Examples:
     - `// FR-016: User has exactly one team` → `// User has exactly one team`
     - `// T040: Find orphaned CaseRecords` → `// Find orphaned CaseRecords`
     - `* FR-012: Automatic timestamp updates` → `* Automatic timestamp updates`
     - Remove multi-line comments that only list spec-kit tags with no other value

6. **Verify Changes**:
   - Ensure helpful comments remain
   - Ensure no spec-kit tags remain in the file

7. **Complete Task**:
   - Use TaskUpdate to set status to "completed"
   - Return to step 1

8. **No More Work**:
   - When TaskList shows no available tasks
   - Send message to team-lead: "No more tasks available, waiting for assignment or shutdown"
   - Wait for further instructions or shutdown request

### Spec-Kit Tag Patterns to Remove

The following patterns should be removed from comments:

- `FR-\d+` - Functional Requirements (e.g., FR-016, FR-042, FR-001 to FR-064) - **WITH hyphen**
- `SC-\d+` - Success Criteria (e.g., SC-001, SC-014, SC-001 to SC-015) - **WITH hyphen**
- `T\d{3}` - Task tracking (e.g., T001, T040, T051, T001 to T084) - **NO hyphen, three digits**
- `US\d+` - User Stories (e.g., US1, US2, US1 to US7) - **NO hyphen**

### Comment Preservation Rules

**KEEP these types of comments:**

1. **Architectural explanations**:
   - "Use $graphLookup for efficient chain traversal"
   - "Dual-write pattern ensures consistency"

2. **Algorithm descriptions**:
   - "Stage 1: Join with Case collection"
   - "Follow the overwrittenCaseId chain to find the current unified Case"

3. **Performance notes**:
   - "~80% faster than sequential queries"
   - "Parallel queries - ~50% faster than sequential"

4. **Error handling patterns**:
   - "Fire-and-forget: don't throw, let the cron scheduler run it again"
   - "Non-blocking, errors logged but don't fail case access"

5. **Important constraints**:
   - "Safety limit to prevent infinite loops"
   - "Must use $addToSet here because findOneAndUpdate doesn't trigger pre-save hooks"

**REMOVE these types of comments:**

1. **Spec-kit references only**:
   - "FR-016: User has exactly one team" → keep the explanation, remove "FR-016:"
   - "Per FR-023: CaseRecord creation is now part..." → remove "Per FR-023:"
   - "SC-014: 90% test coverage" → keep the requirement, remove "SC-014:"
   - "T040: Find orphaned CaseRecords" → keep the action, remove "T040:"
   - "US1: Team-specific case creation" → remove entirely (user story labels)

2. **Multi-line spec-kit blocks**:

   ```
   // Remove this entire block:
   * FR-012: Automatic timestamp updates
   * FR-010: Array deduplication (caseStateFlags, caseRecordOwners)
   * SC-014: Test coverage target
   ```

3. **Development tracking notes**:
   - Metrics implementation example comments with FR/SC tags
   - Comments that only reference task numbers without context

### Edge Cases

**Multiple Tags on One Line**:

- Remove all tags: `// FR-016, FR-017, FR-018: Team assignment` → `// Team assignment`
- Remove all tags: `// T032, T033, T034, T035: CaseRecord merge` → `// CaseRecord merge`

**Tag Mid-Sentence**:

- `// Update per FR-027 when case changes` → `// Update when case changes`
- `// Per SC-014, achieve 90% coverage` → `// Achieve 90% coverage`

**Only Tag, No Context**:

- Remove entire comment line if it contains only a spec-kit tag
- Examples: `// FR-016:`, `// T040:`, `// SC-014:`, `// US1:`

### Error Handling

**Worker Agent Errors**:

- If Edit fails, log error in task and mark as failed
- Move to next task
- Team lead should review failed tasks

**File Not Found**:

- Mark task as failed with reason
- Notify team lead
- Continue with next task

**No Tasks Available**:

- Worker waits for new assignments
- Sends status message to team lead
- Team lead can assign more tasks or initiate shutdown

### Validation

Before marking task complete, verify:

- ✅ All spec-kit tags removed from file (FR-XXX, SC-XXX, TS-XXX, TXXX, USX)
- ✅ Helpful comments preserved
- ✅ No syntax errors introduced
- ✅ File still has meaningful comments

After all tasks complete:

- ✅ Run Grep to verify no spec-kit tags remain in files:
  - `grep -r "FR-\d+" --include="*.js"`
  - `grep -r "SC-\d+" --include="*.js"`
  - `grep -r "TS-\d+" --include="*.js"`
  - `grep -r "\bT\d{3}\b" --include="*.js"`
  - `grep -r "\bUS\d+\b" --include="*.js"`
- ✅ All tasks marked as completed
- ✅ Team cleaned up

## Example Output

```
🚀 Starting parallel comment cleanup...

Creating team "comment-cleanup-team"...
✅ Team created

Scanning codebase for spec-kit tags...
Found 15 files requiring cleanup:
  - backend/api/services/caseRecordHealingService.js
  - backend/api/helpers/caseHelpers.js
  - backend/api/models/caseModel.js
  - backend/api/models/caseRecordModel.js
  - backend/api/controllers/caseNumLinkController/getCaseIdFromCaseNums.js
  - backend/api/controllers/caseNumLinkController/overwriteCaseId.js
  - ... (9 more files)

Creating 15 tasks...
✅ Tasks created

Spawning 3 worker agents...
✅ cleanup-worker-1 spawned
✅ cleanup-worker-2 spawned
✅ cleanup-worker-3 spawned

Monitoring progress...

[cleanup-worker-1] Completed: Clean spec-kit tags from caseRecordHealingService.js
[cleanup-worker-2] Completed: Clean spec-kit tags from caseHelpers.js
[cleanup-worker-3] Completed: Clean spec-kit tags from caseModel.js
[cleanup-worker-1] Completed: Clean spec-kit tags from getCaseIdFromCaseNums.js
[cleanup-worker-2] Completed: Clean spec-kit tags from overwriteCaseId.js
...

✅ All 15 tasks completed

Shutting down worker agents...
✅ cleanup-worker-1 shutdown
✅ cleanup-worker-2 shutdown
✅ cleanup-worker-3 shutdown

Cleaning up team resources...
✅ Team deleted

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Comment cleanup complete!

Summary:
  - 15 files cleaned
  - 0 errors
  - All spec-kit tags removed
  - Helpful comments preserved

Verification:
  - No FR-XXX tags remaining in non-test files (FR-001 to FR-064)
  - No SC-XXX tags remaining in non-test files (SC-001 to SC-015)
  - No TS-XXX tags remaining in non-test files (TS-5, TS-9, etc.)
  - No TXXX tags remaining in non-test files (T001 to T084)
  - No USX tags remaining in non-test files (US1 to US7)

Next steps:
  - Review changes: git diff
  - Verify helpful comments remain
  - Commit changes: git add . && git commit -m "chore: remove spec-kit comment tags"
```

## Context

Additional user context: $ARGUMENTS

## Notes

- This command uses parallel execution via team agents for efficiency
- The team lead coordinates but does not edit files directly
- Worker agents work independently and claim tasks as they complete work
- Task system prevents conflicts (each task claimed by only one agent)
- Failed tasks can be reviewed and manually fixed if needed
- Test files are excluded to preserve test identification tags
