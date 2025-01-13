-- Load Yazi plugins
require("folder-rules"):setup()
require("searchjump"):setup({
	unmatch_fg = "#b2a496",
	match_str_fg = "#000000",
	match_str_bg = "#73AC3A",
	first_match_str_fg = "#000000",
	first_match_str_bg = "#73AC3A",
	lable_fg = "#EADFC8",
	lable_bg = "#BA603D",
	only_current = false, -- only search the current window
	show_search_in_statusbar = true,
	auto_exit_when_unmatch = true,
	enable_capital_lable = false,
	search_patterns = {}, -- demo:{"%.e%d+","s%d+e%d+"}
})

local config_dir = os.getenv("HOME") .. "/.config"
local starship_conf = config_dir .. "/yazi/yazi-starship.toml"
-- local starship_conf = config_dir .. "/starship.toml"
require("starship"):setup({ config_file = starship_conf })

-- Give Yazi a border
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})
