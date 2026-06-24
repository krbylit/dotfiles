function brewadd
    # Trust any tap casks first so install doesn't require a manual `brew trust`
    for arg in $argv
        if not string match -q -- '-*' $arg
            brew trust --cask $arg 2>/dev/null
        end
    end
    brew install $argv
    brew bundle dump --force --no-vscode --file="$HOME/Brewfile"
end
