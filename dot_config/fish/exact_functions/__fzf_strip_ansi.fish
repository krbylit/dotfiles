function __fzf_strip_ansi
    string replace -r '\x1b\[[0-9;]*[[:alpha:]]' '' -- $argv
end
