function yazicd --wraps='yazi' --description 'yazi with cwd'
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    # Disable cursor trail while in yazi
    # kitten @ load-config --override cursor_trail=0
    set -x YAZI_ID (random)

    yazi $argv --cwd-file "$tmp" --client-id "$YAZI_ID"
    # FIXME: need to have yazi open a tab in cwd in the loaded last session, but emit is not working
    # Not working because all commands after `yazi` execute after exiting
    # echo $YAZI_ID
    # YAZI_ID="$YAZI_ID" ya emit tab_create
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
