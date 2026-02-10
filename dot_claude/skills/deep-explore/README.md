# Deep Explore Skill

Automatic deep codebase exploration using coordinated agent teams.

## What It Does

This skill automatically triggers when understanding requires tracing across multiple parts of the codebase. It spawns 3-5 specialized agents to explore different aspects in parallel, coordinates debate to verify findings, and synthesizes comprehensive reports.

## When It Triggers

### Automatic Activation

- "How does X work?" (where X spans multiple files)
- "Explain this file" (when understanding requires system context)
- "Trace the flow of Y"
- "What happens when..."
- Questions about architecture, patterns, or integration

### Manual Invocation

```
/deep-explore <feature-name>
```

## How It Works

1. **Initial Discovery** - Lead explorer assesses scope and complexity
2. **Agent Spawning** - 3-5 specialized agents explore orthogonal focus areas
3. **Agent Debate** - Cross-verification of dependencies and data flow
4. **Synthesis** - Comprehensive report with verified findings
5. **Answer** - Direct answer to user's question

## Supporting Files

- **SKILL.md** - Main skill definition with YAML frontmatter
- **README.md** (this file) - Usage guide

## Best Practices

1. Skill runs in forked context with general-purpose agent
2. Only loads when understanding requires 3+ files
3. Generates `EXPLORATION_[name]_[timestamp].md` for substantial features
4. Trust consensus findings - verified through agent debate

## Example

```
You: How does person query caching work?

Claude: I'll perform a deep exploration using specialized agent teams...
[Spawns 4 agents: API layer, Domain logic, Infrastructure, Cross-cutting]
[Agents explore and debate findings]
[Generates comprehensive report]
[Answers question with insights]
```

## Related

- `/help.explore-feature` - Manual exploration command (similar functionality)
- Uses Task tool to spawn and coordinate agents
- Saves reports for future reference
