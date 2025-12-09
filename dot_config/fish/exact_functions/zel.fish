function zel
    if test (count $argv) -eq 0
        zellij
        return
    end

    set arg $argv[1]

    if test $arg = l
        zellij list-sessions
        return
    end

    if zellij list-sessions | rg -q $arg
        zellij attach $arg
    else
        zellij -s $arg
    end
end
