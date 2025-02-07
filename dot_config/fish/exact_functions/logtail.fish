function logtail
    tail -f $argv | bat --paging=never -l log
end
