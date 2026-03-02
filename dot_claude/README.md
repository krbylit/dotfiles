You have access to two capabilities that fundamentally change how you operate. Read this carefully — it affects your workflow, coordination patterns, and how you build institutional knowledge.

## Capability 1: Claude Code Teams

Multi-agent coordination with shared task lists, direct messaging, and task dependencies.

### Tools

- **TeamCreate** — Creates a named team with a shared task list
- **TaskCreate** — Create tasks with subject, description, and activeForm (present-continuous for spinner). Tasks start as `pending`
- **TaskList** — See all tasks, status, owners, and blockedBy dependencies
- **TaskGet** — Full details on a specific task
- **TaskUpdate** — Update status (`pending` → `in_progress` → `completed`), assign `owner`, set dependencies (`addBlocks`/`addBlockedBy`), or `deleted` to remove
- **SendMessage** — Direct messages (`type: "message"` with `recipient`), broadcasts (`type: "broadcast"` — use sparingly), shutdown requests, plan approval responses

### Workflow

1. Team lead creates team → creates tasks → spawns agents as teammates
2. Teammates check TaskList, claim unassigned/unblocked tasks (prefer lowest ID first)
3. Teammates work on tasks, mark completed, check for next work
4. Communication via SendMessage — your plain text is NOT visible to teammates, you MUST use SendMessage
5. Teammates go idle between turns — this is normal, sending a message wakes them
6. When done, team lead sends shutdown requests and deletes team

### Key Patterns

- **Task dependencies as structural gates:** A release task `blockedBy` a QA review task means release literally cannot proceed until QA completes. This turns advisory processes into enforced gates.
- **Parallel consultation:** Multiple agents work simultaneously on different aspects, coordinated through the shared task list. No more sequential relay through the user.
- **Direct communication:** Message other agents directly for consultation, escalation, or coordination. No relay needed.
- **Scope visibility:** Task list additions/removals make scope changes auditable.

### When to Use Teams vs Direct Agent Spawning

- **Teams:** Multi-agent work with coordination needs, dependencies, or parallel streams
- **Direct spawn (Task tool):** Single-agent tasks that don't need coordination

## Capability 2: Persistent Memory

A shared memory directory persists across conversations. Location varies per project (check your system prompt for the path). Contents survive between sessions.

### How It Works

- **MEMORY.md** is always loaded into the system prompt (first 200 lines) — keep it concise
- **Topic files** linked from MEMORY.md hold detailed domain knowledge
- Use **Write** and **Edit** tools to update memory files
- Organize semantically by topic, not chronologically

### Memory Conventions

**File naming:** `{owner}-{topic}.md` (e.g., `architect-decisions.md`, `pm-velocity.md`)

**Ownership rules:**

1. **Single owner per file.** One agent writes; others read. No shared writes.
2. **Cross-reference, don't copy.** Link to other agents' files, don't duplicate content.
3. **Create files only when you have content.** No empty placeholders or "(Record X here)" sections.
4. **Last-verified dates.** Include `Last verified: YYYY-MM-DD` near the top of every topic file.

**MEMORY.md structure:**

- Project Context (~5-8 lines): Project name, org, tech stack, agent ecosystem
- Memory File Registry (table): filename | owner | purpose | last-verified date
- Cross-Cutting Decisions (~5 lines): Rules that affect multiple agents
- Active Alerts (~3 lines): Time-sensitive coordination signals (empty when none)
- Target under 80 lines. Hard cap at 120. No agent-specific content — that goes in topic files.

### Information Taxonomy (what goes where)

| Question                                            | Location                                 |
| --------------------------------------------------- | ---------------------------------------- |
| "How should this agent behave?"                     | Agent definition (`.claude/agents/*.md`) |
| "What does every agent need to know?"               | MEMORY.md (shared index)                 |
| "What has this agent learned across conversations?" | Memory topic file (`{owner}-{topic}.md`) |
| "What are the org's processes and standards?"       | docs/ directory                          |
| "What does the software currently do?"              | Feature documentation / source code      |

**Decision heuristic:**

1. Will it change next conversation? → Memory topic file
2. Does every agent need it every time? → MEMORY.md (if < 2 lines)
3. Is it about how an agent should behave? → Agent definition
4. Is it an organizational process? → docs/
5. Is it a philosophical principle? → Project-level config (PLAYBOOK.md, CLAUDE.md, etc.)

### Memory Is "Last Known State" Not Ground Truth

Always verify against current source (code, docs, database) before acting on memory for critical decisions. Include timestamps. Prune stale content.

## How These Capabilities Affect Your Work

### What Changes

- **Speed:** Direct agent-to-agent communication replaces relay-through-user
- **Continuity:** Decisions, patterns, and context persist across conversations
- **Enforcement:** Task dependencies make processes structural, not advisory
- **Parallelism:** Multiple agents work simultaneously, coordinated through shared task lists

### What Does NOT Change

- **Your governance boundaries.** Same decision authority. Same escalation rules. Same scope.
- **Your responsibilities.** Teams and Memory make you faster and more informed within your existing role.
- **Your consultation patterns.** Same partners, now via direct messaging instead of relay.

### Practical Applications

- **Design/code reviews** become blocking task dependencies — nothing proceeds without approval
- **Quality gates** are enforced structurally, not just advised
- **Persistent registers** (tech debt, risks, velocity, compliance status) accumulate across sessions
- **Escalations** go direct to the appropriate agent with full context
- **Institutional knowledge** builds over time — patterns, heuristics, and lessons learned persist

### Sensitivity Guidelines for Memory

- Never store secrets, credentials, or PII in memory files
- People-related data: store patterns and approaches, not specific personnel details
- Memory files are on disk — assume anything written could be read by anyone with filesystem access
- Reference external systems of record for sensitive details rather than duplicating them

### Risks to Watch For

- **Memory staleness:** Verify before acting on old data. Include timestamps.
- **Over-formalization:** Not every consultation needs a task dependency. Match ceremony to significance.
- **Memory bloat:** Keep files focused. Prune outdated entries. No empty placeholders.
- **Duplication across agents:** Cross-reference, don't copy. Each fact should live in one place.
- **False confidence:** Memory is a fast-path hint, not ground truth. Verify for write operations.

## Your Task

After reading this briefing, adapt your existing responsibilities to leverage Teams and Memory naturally. Think about:

1. What knowledge from your domain would you persist in memory?
2. How do task dependencies change your enforcement model?
3. How does direct messaging change your consultation patterns?
4. What sensitivity boundaries apply to your memory content?

These capabilities are tools in service of your existing role — use them to be more effective, not to expand your scope
