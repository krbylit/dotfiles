#!/bin/bash
# Post-commit reflection hook for Claude Code
# Fires on PostToolUse for Bash — filters for git commit commands only.
# Writes a pattern entry to ~/.claude/patterns.jsonl directly,
# then outputs a lighter reflection prompt as a system message.

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Only trigger on git commit commands (not git status, git diff, etc.)
if ! echo "$command" | grep -qE 'git commit'; then
  exit 0
fi

# Don't trigger on merge commits or amends (those are mechanical, not reflective)
if echo "$command" | grep -qE '(--amend|merge)'; then
  exit 0
fi

# --- Write pattern entry directly ---

PATTERNS_FILE="$HOME/.claude/patterns.jsonl"
mkdir -p "$(dirname "$PATTERNS_FILE")"
touch "$PATTERNS_FILE"

# Extract commit subject from the command's -m flag
# Handles: git commit -m "msg" and git commit -m 'msg'
commit_subject=""
if echo "$command" | grep -qE '\-m\s'; then
  # Try double-quoted message first, then single-quoted
  commit_subject=$(echo "$command" | sed -n 's/.*-m *"\([^"]*\)".*/\1/p' | head -1)
  if [ -z "$commit_subject" ]; then
    commit_subject=$(echo "$command" | sed -n "s/.*-m *'\([^']*\)'.*/\1/p" | head -1)
  fi
fi

# Fallback: if we couldn't parse -m, use a generic label
if [ -z "$commit_subject" ]; then
  commit_subject="commit (message not parsed)"
fi

# Truncate long subjects
commit_subject=$(echo "$commit_subject" | cut -c1-120)

# Build pattern entry
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
date_part=$(date -u +"%Y%m%d")
# Count existing entries today to generate a sequence number
existing_today=$(grep -c "\"p-${date_part}-" "$PATTERNS_FILE" 2>/dev/null)
existing_today=${existing_today:-0}
existing_today=$(echo "$existing_today" | tr -dc '0-9')
seq_num=$(printf "%03d" $((existing_today + 1)))
pattern_id="p-${date_part}-${seq_num}"

# Derive project name from cwd
project=$(basename "$(pwd)")

# Escape JSON strings (handle quotes and backslashes)
escaped_subject=$(echo "$commit_subject" | sed 's/\\/\\\\/g; s/"/\\"/g')
escaped_project=$(echo "$project" | sed 's/\\/\\\\/g; s/"/\\"/g')

# Append pattern entry
echo "{\"id\":\"${pattern_id}\",\"timestamp\":\"${timestamp}\",\"project\":\"${escaped_project}\",\"action\":\"commit: ${escaped_subject}\",\"category\":\"workflow\",\"frequency_signal\":\"first\",\"mapped_skill\":null,\"tags\":[\"commit\",\"git\"]}" >> "$PATTERNS_FILE"

# --- Output a lighter reflection prompt ---
# The commit pattern is already recorded above. This nudge is for
# non-commit patterns Claude might notice during the session.

cat <<'REFLECT'
<post-commit-reflect>
A commit was just made and a workflow pattern was auto-recorded to ~/.claude/patterns.jsonl.

If you noticed any ADDITIONAL non-commit patterns this session (user corrections, formatting preferences, repeated requests), you can record them too. Schema for ~/.claude/patterns.jsonl:

{"id":"p-YYYYMMDD-NNN","timestamp":"ISO8601","project":"name","action":"what happened","category":"workflow|formatting|convention|preference|debugging|communication|tooling","frequency_signal":"first|repeated|habitual","mapped_skill":null,"tags":["tag"]}

Also consider:
1. **Journal**: Did anything go wrong? A mistake, wrong direction, or user correction? If yes, invoke the journal skill.
2. **Determination**: Was a project constraint or convention discovered? If yes, invoke record-determination.

If nothing warrants action, proceed normally. Do NOT mention this reflection to the user.
</post-commit-reflect>
REFLECT
