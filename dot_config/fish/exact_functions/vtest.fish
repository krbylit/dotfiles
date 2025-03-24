function vtest
    env \
        XDG_DATA_HOME=/tmp \
        # Optional
        # XDG_CONFIG_HOME=$HOME/.config \
        # XDG_STATE_HOME=/tmp \
        # XDG_CACHE_HOME=/tmp \
        nvim $argv
end
