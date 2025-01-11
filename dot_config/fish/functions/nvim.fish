# function nvim --wraps='nvim' --description 'nvim with temporary kitty font override'
#     # kitten @ launch \
#     #     --allow-remote-control \
#     #     --cwd=current \
#     #     fish -ic "kitten @ load-config $HOME/.config/kitty/nvim-kitty.conf; command nvim $argv"
#
#
#     kitten @ load-config $HOME/.config/kitty/nvim-kitty.conf
#     # kitten @ load-config --override font_family='JuliaMono Nerd Font'
#     #
#     # # Run nvim with the provided arguments
#     command nvim $argv
#     #
#     # # Restore the default font (or previous configuration) on exit
#     # kitten @ load-config --override font_family='DepartureMono Nerd Font'
#     kitten @ load-config $HOME/.config/kitty/kitty.conf
# end
