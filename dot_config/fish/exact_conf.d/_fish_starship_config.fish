function starship_transient_prompt_func
    # Accept the arguments that Starship passes but pass them through to the module
    # Arguments: --terminal-width, --status, --pipestatus, --keymap, --cmd-duration, --jobs
    starship module custom.angular_transient_prompt $argv
    # starship module custom.curvy_transient_prompt $argv
end
function starship_transient_rprompt_func
    # Accept the arguments that Starship passes but pass them through to the module
    starship module custom.transient_rprompt $argv
end
