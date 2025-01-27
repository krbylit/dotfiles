function brewrem
    brew uninstall $argv
    brew bundle dump --force --no-vscode --file="$HOME/Brewfile"
end
