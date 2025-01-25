#!/bin/bash

# Function to log messages with timestamps
log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
	log "Homebrew is not installed. Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	log "Homebrew is already installed."
fi

# Run brew bundle and capture stderr
log "Running brew bundle..."
{
	brew bundle --cleanup --file="$HOME/Brewfile"
} 2> >(
	errors=$(cat)
	typeset -p errors >&2
)

# Check if there were errors
if [ -n "$errors" ]; then
	log "brew bundle encountered the following errors:"
	echo "$errors"
else
	log "brew bundle completed successfully without errors."
fi
