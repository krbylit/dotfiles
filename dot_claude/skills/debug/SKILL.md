---
name: debug
description: Systematic debugging workflow
---

## Debugging Protocol
1. **Reproduce**: Confirm the exact error/behavior the user reports
2. **Investigate**: Read relevant source code, logs, and stack traces
3. **Hypothesize**: State your theory of the root cause BEFORE proposing any fix
4. **Verify**: Ask the user to confirm your hypothesis or provide counter-evidence
5. **Fix**: Only then implement the minimal targeted fix
6. **Validate**: Run tests/checks to confirm the fix works

NEVER try quick-fix guesses. NEVER disable features as a debugging step.
