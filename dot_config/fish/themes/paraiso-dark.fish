# Paraiso Dark Color Palette (matches ghostty "Paraiso Dark")
# Sourced session-locally for the Neovim <c-/> popup shell only.
# Uses `set -g` so it shadows the universal theme for this session
# without ever writing universal variables read by other fish shells.
set -l foreground a39e9b
set -l selection 4f424c
set -l comment 776e71
set -l red ef6155
set -l orange f99b15
set -l yellow fec418
set -l green 48b685
set -l purple 815ba4
set -l cyan 5bc4bf
set -l pink e96ba8

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_option $pink
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection
