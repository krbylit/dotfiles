function n --description "Create and open new note in Obsidian vault"
    nvim +"Obsidian new "(date +%Y%m%d%H%M%S)
end
