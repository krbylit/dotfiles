#!/usr/bin/env bash
# This script finds the first empty space on each display and focuses it.

# Loop through each display
for display in $(yabai -m query --displays | jq -r '.[].index'); do
	# Get all spaces for this display
	spaces=$(yabai -m query --displays --display $display | jq -r '.spaces[]')

	# Loop through spaces on the display
	for space in $spaces; do
		# Check if the space is empty by counting windows in it
		window_count=$(yabai -m query --spaces --space $space | jq '.windows | length')

		# If no windows are found, focus on this space
		if [ "$window_count" -eq 0 ]; then
			yabai -m space --focus $space
			break # Exit after finding the first empty space on this display
		fi
	done
done
