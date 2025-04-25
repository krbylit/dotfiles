function timer
    set -l duration $argv[1]
    tclock timer -d $duration -e terminal-notifier -title tclock -message "'Time is up!'"
end
