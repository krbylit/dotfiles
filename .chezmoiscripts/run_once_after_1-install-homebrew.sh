#!/usr/bin/env bash

# Function to log messages with timestamps
log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
	log "Homebrew is not installed. Installing Homebrew..."
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	export PATH="/opt/homebrew/bin:$PATH"
	export PATH="/usr/local/bin:$PATH"
else
	log "Homebrew is already installed."
fi

# Run brew bundle and capture stderr
log "Running brew bundle..."
tmp_err=$(mktemp) # Create a temporary file for stderr
if ! brew bundle --cleanup --file="$HOME/Brewfile" 2>"$tmp_err"; then
	log "brew bundle encountered errors:"
	cat "$tmp_err"
else
	log "brew bundle completed successfully without errors."
fi
rm -f "$tmp_err" # Clean up the temporary file
