# Initialize zellij tab renaming
if set -q ZELLIJ
    # Just ensure the function is loaded (triggers autoload without executing)
    functions -q zellij_tab_rename
end
