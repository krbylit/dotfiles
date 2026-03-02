#!/usr/bin/env bash
# First Prompt Quality Evaluation Hook
# Runs the Prompt Quality Evaluation Protocol on the FIRST user prompt only
# To enable, put this in `.claude/settings.json`:
# ```json
#   "hooks": {
#     "UserPromptSubmit": [
#       {
#         "hooks": [
#           {
#             "type": "command",
#             "command": "${HOME}/.claude/first-prompt-evaluator.sh",
#             "timeout": 10
#           }
#         ]
#       }
#     ]
#   }
# ```

set -euo pipefail

# Read input from stdin (hook context)
input=$(cat)

# Extract session ID from environment or input
# Claude Code sets CLAUDE_SESSION_ID or we can use the session-env directory
session_id="${CLAUDE_SESSION_ID:-unknown}"
marker_dir="${CLAUDE_CONFIG_DIR}/session-env/${session_id}"
marker_file="${marker_dir}/.first-prompt-evaluated"

# If session directory doesn't exist, fall back to a timestamp-based approach
if [[ ! -d "$marker_dir" ]]; then
  marker_dir="${CLAUDE_CONFIG_DIR}/session-env"
  marker_file="${marker_dir}/.first-prompt-evaluated-${session_id}"
fi

# Create marker directory if needed
mkdir -p "$marker_dir"

# Check if this is the first prompt of the session
if [[ -f "$marker_file" ]]; then
  # Not the first prompt - output empty JSON and exit
  echo '{}'
  exit 0
fi

# Mark that we've run the evaluation
touch "$marker_file"

# Output the evaluation protocol as additional context
cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "# Prompt Quality Evaluation Protocol - FIRST PROMPT ANALYSIS\n\nYou must evaluate the quality and likelihood of success for this FIRST user prompt using the following protocol:\n\n## Evaluation Steps\n\n1. **Decompose the prompt into:**\n   - Objective\n   - Constraints\n   - Context\n   - Deliverables\n   - Acceptance criteria\n\n2. **Evaluate across the 10 quality dimensions (score 0-5 each):**\n   - Problem Definition Clarity\n   - Context Completeness\n   - Constraint Specificity\n   - Output Verifiability\n   - Hallucination Resistance\n   - Architectural Alignment\n   - Edge Case Awareness\n   - Maintainability Orientation\n   - Testability Requirement\n   - Ambiguity Density\n\n3. **Score each dimension from 0 to 5 using explicit justification.**\n\n4. **Identify:**\n   - Missing constraints\n   - Hidden assumptions\n   - Areas likely to cause hallucination\n   - Architectural conflicts\n   - Missing verification mechanisms\n\n5. **Rewrite the prompt into a \"production-grade\" version.**\n\n6. **Provide:**\n   - Original Score (average of all dimensions)\n   - Rewritten Prompt\n   - Improved Score (average of all dimensions)\n   - Delta Explanation (what changed and why)\n\n7. **Do not comment on writing style. Evaluate engineering robustness only.**\n\n---\n\n**CRITICAL**: After completing the evaluation, ask the user if they want to:\n- (a) Proceed with the ORIGINAL prompt\n- (b) Proceed with the REWRITTEN prompt\n- (c) Provide their own modified version\n\nThen execute the chosen prompt normally."
  }
}
EOF

exit 0
