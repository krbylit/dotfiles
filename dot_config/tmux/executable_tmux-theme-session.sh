#!/usr/bin/env bash
#
# tmux-theme-session.sh — Theme a single tmux session based on its name
#
# Called by tmux session-created hook. Reads TMUX_SESSION from env
# or the most recently created session.

SESSION="${1:-$(tmux display-message -p '#{session_name}' 2>/dev/null)}"
[[ -z "$SESSION" ]] && exit 0

# Only theme Gas Town sessions (hq-*, th-*, gt-monitors, gt-fish)
# Skip regular user tmux sessions
case "$SESSION" in
    hq-*|th-*|gt-monitors|gt-fish) ;; # Gas Town — continue
    *) exit 0 ;; # Not Gas Town — skip
esac

# --- Color assignments by agent type ---
# Format: bg fg sfg tab
case "$SESSION" in
    hq-mayor)       bg="#094338" fg="#3a7868" sfg="#589888" tab="#06322a" ;;
    hq-deacon)      bg="#423758" fg="#6c6088" sfg="#8878a8" tab="#322a42" ;;
    hq-boot)        bg="#14161e" fg="#3c4458" sfg="#505868" tab="#0e1016" ;;
    *-witness)      bg="#564747" fg="#806c6c" sfg="#a08888" tab="#403636" ;;
    *-refinery)     bg="#583c2e" fg="#80664c" sfg="#a08060" tab="#422d22" ;;
    *-crew-*)       bg="#2b3a58" fg="#586c98" sfg="#7888b8" tab="#202c42" ;;
    gt-monitors|gt-fish) bg="#1a1c24" fg="#4c5468" sfg="#606878" tab="#141618" ;;
    *)              bg="#553036" fg="#805058" sfg="#a06870" tab="#402428" ;;  # polecats/default
esac

# Pane styling
tmux set-option -t "$SESSION" window-style "bg=$bg,fg=$sfg" 2>/dev/null
tmux set-option -t "$SESSION" window-active-style "bg=$bg,fg=$sfg" 2>/dev/null

# Status bar
tmux set-option -t "$SESSION" status-style "bg=$bg,fg=$sfg" 2>/dev/null
tmux set-option -t "$SESSION" status-left-style "bg=$bg,fg=$sfg,bold" 2>/dev/null
tmux set-option -t "$SESSION" status-right-style "bg=$bg,fg=$sfg" 2>/dev/null

# Borders
tmux set-option -t "$SESSION" pane-border-style "fg=$tab" 2>/dev/null
tmux set-option -t "$SESSION" pane-active-border-style "fg=$sfg" 2>/dev/null

# Messages
tmux set-option -t "$SESSION" message-style "bg=$tab,fg=$sfg" 2>/dev/null

# Window tabs (all existing windows)
for win in $(tmux list-windows -t "$SESSION" -F '#{window_index}' 2>/dev/null); do
    tmux set-window-option -t "$SESSION:$win" window-status-format " #I #W " 2>/dev/null
    tmux set-window-option -t "$SESSION:$win" window-status-current-format " #I #W " 2>/dev/null
    tmux set-window-option -t "$SESSION:$win" window-status-style "bg=$bg,fg=$fg" 2>/dev/null
    tmux set-window-option -t "$SESSION:$win" window-status-current-style "bg=$tab,fg=$sfg,bold" 2>/dev/null
    tmux set-window-option -t "$SESSION:$win" window-status-separator "" 2>/dev/null
    tmux set-window-option -t "$SESSION:$win" window-style "bg=$bg,fg=$sfg" 2>/dev/null
    tmux set-window-option -t "$SESSION:$win" window-active-style "bg=$bg,fg=$sfg" 2>/dev/null
done

# Hook for new windows in this session
tmux set-hook -t "$SESSION" after-new-window \
    "set-window-option window-status-format ' #I #W '; \
     set-window-option window-status-current-format ' #I #W '; \
     set-window-option window-status-style 'bg=$bg,fg=$fg'; \
     set-window-option window-status-current-style 'bg=$tab,fg=$sfg,bold'; \
     set-window-option window-status-separator ''; \
     set-window-option window-style 'bg=$bg,fg=$sfg'; \
     set-window-option window-active-style 'bg=$bg,fg=$sfg'" 2>/dev/null

# Guard against external tools (e.g. gt theme apply) overwriting status-style.
# Re-apply our colors whenever a session-level option is set.
tmux set-hook -t "$SESSION" after-set-option \
    "set-option -t $SESSION status-style 'bg=$bg,fg=$sfg'; \
     set-option -t $SESSION status-left-style 'bg=$bg,fg=$sfg,bold'; \
     set-option -t $SESSION status-right-style 'bg=$bg,fg=$sfg'" 2>/dev/null
