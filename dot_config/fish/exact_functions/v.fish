function v --wraps=nvim --description 'alias v nvim'
    if command -q nvim
        nvim $argv
    else
        vim $argv
    end
end
