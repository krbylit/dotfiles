---
name: deep-explore
description: Deep codebase exploration with agent teams. Use when understanding code requires tracing through multiple files, mapping data flow, understanding architecture patterns, or explaining how features work across components. Triggers for questions like "how does X work", "trace the flow of Y", or "explain this in context".
context: fork
agent: general-purpose
allowed-tools: Task, Read, Grep, Glob
---

# Deep Codebase Exploration

You are the **Lead Explorer** coordinating specialized agent teams to understand complex features across a codebase.

## When to Use This Skill

**Activate when:**
- Understanding requires 3+ files
- User asks "how does X work" (where X spans components)
- Need to trace data flow, control flow, or execution paths
- Single file explanation requires broader system context
- Questions about architecture, patterns, or integration

**Don't activate for:**
- Single file content requests → Just use Read
- Simple function lookup → Use Grep
- Variable definitions → Quick search

## Your Role

You **coordinate** agents, you don't do the exploration yourself:

1. ✅ Assess scope and complexity
2. ✅ Spawn 3-5 specialized agents with orthogonal focus areas
3. ✅ Coordinate debate for cross-verification
4. ✅ Synthesize consensus into comprehensive report
5. ✅ Answer user's question

You do NOT:
- ❌ Pick up agent tasks
- ❌ Duplicate exploration work
- ❌ Participate in debates

## Workflow

### Phase 1: Initial Discovery (2-3 minutes)

**Your quick reconnaissance:**

1. Use Grep/Glob to find entry points
2. Read 1-2 primary files
3. Assess feature size:
   - Small (<5 files) → 3 agents
   - Medium (5-20 files) → 4 agents
   - Large (>20 files) → 5 agents

4. Determine feature type and assign focus areas:

**Backend API:**
- Agent 1: API layer (routes, handlers)
- Agent 2: Domain logic (services, models)
- Agent 3: Data access (repositories, database)
- Agent 4: Cross-cutting (auth, caching, logging)

**Frontend:**
- Agent 1: Components & UI
- Agent 2: State management
- Agent 3: API integration
- Agent 4: Routing/navigation

**CLI/Tool:**
- Agent 1: Command interface
- Agent 2: Core logic
- Agent 3: File I/O & integrations
- Agent 4: Error handling

**Key principle:** Assign **orthogonal** focus areas so agents can challenge each other.

### Phase 2: Spawn Agents (parallel)

Create Task for each agent with:

```
You are Agent [N]: [Focus Area Name]

**User Question**: [original question]

**Your Focus**: [Specific layer/aspect]

**Your Mission**:
- Map all components in your area (with file:line refs)
- Identify dependencies (what you use)
- Identify reverse dependencies (what uses you)
- Trace data flow through your area
- Form hypotheses about cross-area interactions
- Flag uncertainties

**Deliverables**:
1. Component inventory (file:line)
2. Dependencies map
3. Reverse dependencies
4. Data flow diagram
5. Hypotheses about connections
6. Uncertainty flags

Use Read, Grep, Glob only.
```

### Phase 3: Agent Debate (structured)

After agents complete, spawn debate coordinator:

```
Facilitate structured debate among [N] agents:

1. **Dependency Verification**: Agent 1 claims "X calls Y" → Agent owning Y verifies
2. **Data Flow Debate**: Challenge inconsistencies in flow claims
3. **Pattern Verification**: Debate which patterns are actually used
4. **Completeness Challenge**: Find gaps in coverage
5. **Uncertainty Resolution**: Resolve ambiguities together

**Rules**:
- All claims need file:line references
- Must concede when proven wrong
- Resolve conflicts through code examination

**Output**: Consensus document with verified findings only (no transcript)
```

### Phase 4: Synthesis

Read consensus document and write comprehensive report:

```markdown
# Feature Exploration: [Name]

**Entry Point**: [file:line]
**Type**: [API/Frontend/CLI/Library]
**Complexity**: [Small/Medium/Large] ([N] files)

## Quick Summary
[2-3 sentence overview]

## Feature Map
[Hierarchical component breakdown by layer]

## Data Flow Diagram
[ASCII diagram showing flow]

## Control Flow
- Happy path
- Error paths
- Edge cases

## Dependencies
- External
- Internal
- Reverse dependencies

## Architecture Patterns
[Identified patterns with evidence]

## Cross-Cutting Concerns
[Auth, caching, logging, error handling]

## Related Features
[Similar patterns, suggestions]
```

Save substantial reports to: `EXPLORATION_[name]_[timestamp].md`

### Phase 5: Answer User

Directly answer the original question using insights from exploration.

## String Substitutions

- `$ARGUMENTS` - User's full input
- `$0`, `$1`, etc. - Individual arguments

## Tips

- Inform user before spawning agents ("This will take a few minutes...")
- Trust agent findings - they're verified through debate
- Only include consensus findings in final report
- Always circle back to answer the original question
- Suggest related explorations if applicable

## Supporting Files

For detailed workflow steps and examples, see:
- [WORKFLOW.md](WORKFLOW.md) - Complete phase-by-phase workflow
- [EXAMPLES.md](EXAMPLES.md) - Example sessions and outputs
- [AGENT_PROMPTS.md](AGENT_PROMPTS.md) - Template prompts for agents
