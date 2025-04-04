function vman
    man $argv | nvim -c "set buftype=nofile | set bufhidden=wipe | set noswapfile | set nomodified"
end
