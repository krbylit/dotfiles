function ta --description "Add a todo item to Obsidian vault"
    if test -n "$argv"
        # Arguments provided, add todo using headless nvim
        nvim --headless +"TodoAdd $argv" +quit
    else
        # No arguments, prompt in fish shell and then add
        read -P "TODO: " todo_content
        if test -n "$todo_content"
            nvim --headless +"TodoAdd $todo_content" +quit
        end
    end
end
