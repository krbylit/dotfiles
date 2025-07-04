function y --wraps='yazi' --description 'yazi with cwd'
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    # Disable cursor trail while in yazi
    # kitten @ load-config --override cursor_trail=0
    set yazi_id (random)
    set -x YAZI_ID "$yazi_id"

    yazi $argv --cwd-file "$tmp" --client-id "$yazi_id"
    # FIXME: need to have yazi open a tab in cwd in the loaded last session, but emit is not working
    # ya emit-to $YAZI_ID tab_create $PWD
    # ya emit-to "$yazi_id" tab_create $PWD
    set cwd (cat -- "$tmp")
    if test -n "$cwd" -a "$cwd" != "$PWD"
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
    set -e YAZI_ID
    # Enable cursor trail again on exit
    # kitten @ load-config --override cursor_trail=3
end
