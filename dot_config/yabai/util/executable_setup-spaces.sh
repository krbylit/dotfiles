#!/usr/bin/env sh
# Display-dependent space setup for yabai: derive the space list from the
# current display count, ensure that many spaces exist, label them, pin
# them to displays, and set per-space layouts.
#
# This is the single source of truth for space setup. It is:
#   - sourced by yabairc at startup (so the variables it defines are also
#     available to yabairc's rule sections), and
#   - executed by the display_added/removed/moved signals on hot-plug.
#
# It deliberately does NOT restart yabai and does NOT add rules/signals,
# so it is safe to re-run: app->space rules are label-based and already
# registered, so re-labeling the (possibly new) spaces is all that a
# display change needs. Restarting yabai here would loop, because yabai
# emits a display event on startup.

PADDING=6

DISPLAY_COUNT=$(yabai -m query --displays | jq '. | length')
DISPLAY_2=$((DISPLAY_COUNT > 1 ? 2 : 1))

if [ "$DISPLAY_COUNT" -gt 1 ]; then
	SPACES="term browser code dev misc comms ref debug util"
	DEFAULT_LAYOUT="bsp"
	SEC_SPACES="comms ref debug util"
else
	SPACES="term browser code dev misc comms ref debug"
	DEFAULT_LAYOUT="stack"
	SEC_SPACES="comms ref debug"
fi
MAIN_SPACES="term browser code dev misc"

# Ensure the correct number of spaces exist (create only; never destroy).
current_space_count=$(yabai -m query --spaces | jq 'length')
target_space_count=$(echo "$SPACES" | wc -w | tr -d ' ')
while [ "$current_space_count" -lt "$target_space_count" ]; do
	yabai -m space --create
	current_space_count=$((current_space_count + 1))
done

# Label spaces in order.
i=1
for space in $SPACES; do
	yabai -m space $i --label "$space"
	i=$((i + 1))
done

# Pin spaces to displays. (Re-running prints "already located on the given
# display" for spaces already in place -- harmless.)
for space in $MAIN_SPACES; do
	yabai -m space "$space" --display 1
done
for space in $SEC_SPACES; do
	yabai -m space "$space" --display $DISPLAY_2
done

# Per-space layouts.
yabai -m config --space term layout stack window_gap $PADDING window_opacity off top_padding 0 bottom_padding 0 left_padding 0 right_padding 0
yabai -m config --space browser layout stack
yabai -m config --space code layout stack
yabai -m config --space dev layout $DEFAULT_LAYOUT
yabai -m config --space comms layout $DEFAULT_LAYOUT
yabai -m config --space ref layout $DEFAULT_LAYOUT
yabai -m config --space misc layout $DEFAULT_LAYOUT
yabai -m config --space debug layout $DEFAULT_LAYOUT
if [ "$DISPLAY_COUNT" -gt 1 ]; then
	yabai -m config --space util layout $DEFAULT_LAYOUT
fi
