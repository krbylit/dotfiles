# Set Fish color theme
# Available themes: catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha, tokyonight
# fish_config theme choose catppuccin-macchiato
# fish_config theme choose tokyonight
fish_config theme choose catppuccin-mocha

# Paraiso Dark for the Neovim <c-/> popup shell only. PARAISO_POPUP is set by
# the Snacks terminal launch and propagates Snacks -> zellij -> fish. The theme
# file uses `set -g`, so it shadows the catppuccin universal vars for this
# session only and never leaks to other fish shells.
if set -q PARAISO_POPUP
    source $__fish_config_dir/themes/paraiso-dark.fish
end
