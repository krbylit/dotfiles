function brewadd
    brew install $argv
    brew bundle dump --force --no-vscode --file="$HOME/Brewfile"
end
