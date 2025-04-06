function vtest
    env \
        XDG_DATA_HOME=$XDG_DATA_HOME/nvim-test \
        XDG_STATE_HOME=$XDG_STATE_HOME/nvim-test \
        XDG_CACHE_HOME=$XDG_CACHE_HOME/nvim-test \
        nvim $argv
end
