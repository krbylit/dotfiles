function ldz
    set -l dir_name (basename (pwd))
    set -l path_hash (echo -n (pwd) | md5 | string sub -l 8)
    set -l session "lazydocker-$dir_name-$path_hash"

    if zellij list-sessions -sn 2>/dev/null | grep -qx $session
        zellij attach $session
    else
        zellij -n lazydocker -s $session
    end
end
