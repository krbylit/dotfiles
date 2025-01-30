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

-- Custom right-hand display of size and last modified time
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
