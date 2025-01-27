function y --wraps='yazi' --description 'yazi with cwd'
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    # Disable cursor trail while in yazi
    # kitten @ load-config --override cursor_trail=0
    yazi $argv --cwd-file="$tmp"
    set cwd (cat -- "$tmp")
    if test -n "$cwd" -a "$cwd" != "$PWD"
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
    # Enable cursor trail again on exit
    # kitten @ load-config --override cursor_trail=3
end
