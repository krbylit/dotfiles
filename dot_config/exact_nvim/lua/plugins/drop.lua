-- Animated dashboard / screensaver
-- https://github.com/folke/drop.nvim

-- FIXME: getting error comparing nil to number
local function is_enabled_for_today(themes)
	local current_date = os.date("*t")

	for _, theme in ipairs(themes) do
		if not theme.holidy or theme.month or theme.day or theme.from or theme.to then
			-- No date-specific theme, enable for all dates
			return true
		end
		if theme.holiday then
			-- Check if today is Easter or Thanksgiving
			if current_date.month == 4 and current_date.day == 1 then
				-- Easter
				return true
			elseif
				-- Thanksgiving
				current_date.month == 11
				and current_date.wday == 5
				and current_date.day >= 22
				and current_date.day <= 28
			then
				return true
			end
		elseif theme.month and theme.day then
			-- Exact date match
			if current_date.month == theme.month and current_date.day == theme.day then
				return true
			end
		elseif theme.from and theme.to then
			-- Date range match
			local from_date = { month = theme.from.month, day = theme.from.day }
			local to_date = { month = theme.to.month, day = theme.to.day }

			-- Convert dates to a comparable format (e.g., "MMDD")
			local function date_to_int(date)
				return date.month * 100 + date.day
			end

			local current_date_int = date_to_int(current_date)
			local from_date_int = date_to_int(from_date)
			local to_date_int = date_to_int(to_date)

			if from_date_int <= current_date_int and current_date_int <= to_date_int then
				return true
			end
		end
	end

	return false
end
local all_themes = {
	{ theme = "new_year", month = 1, day = 1 },
	{ theme = "valentines_day", month = 2, day = 14 },
	{ theme = "st_patricks_day", month = 3, day = 17 },
	{ theme = "easter", holiday = "easter" },
	{ theme = "april_fools", month = 4, day = 1 },
	{ theme = "us_independence_day", month = 7, day = 4 },
	{ theme = "halloween", month = 10, day = 31 },
	{ theme = "us_thanksgiving", holiday = "us_thanksgiving" },
	{ theme = "xmas", from = { month = 12, day = 24 }, to = { month = 12, day = 25 } },
	-- { theme = "leaves", from = { month = 9, day = 22 }, to = { month = 12, day = 20 } },
	-- { theme = "snow", from = { month = 12, day = 21 }, to = { month = 3, day = 19 } },
	-- { theme = "spring", from = { month = 3, day = 20 }, to = { month = 6, day = 20 } },
	-- { theme = "summer", from = { month = 6, day = 21 }, to = { month = 9, day = 21 } },
	-- { theme = "arcade" },
	-- { theme = "art" },
	-- { theme = "bakery" },
	-- { theme = "beach" },
	-- { theme = "binary" },
	-- { theme = "bugs" },
	-- { theme = "business" },
	-- { theme = "candy" },
	-- { theme = "cards" },
	-- { theme = "carnival" },
	-- { theme = "casino" },
	{ theme = "cats" },
	-- { theme = "coffee" },
	-- { theme = "cyberpunk" },
	-- { theme = "deepsea" },
	-- { theme = "desert" },
	-- { theme = "dice" },
	-- { theme = "diner" },
	-- { theme = "explorer" },
	-- { theme = "fantasy" },
	-- { theme = "farm" },
	-- { theme = "garden" },
	-- { theme = "jungle" },
	-- { theme = "lunar" },
	-- { theme = "magical" },
	-- { theme = "mathematical" },
	-- { theme = "matrix" },
	-- { theme = "medieval" },
	-- { theme = "musical" },
	-- { theme = "mystery" },
	-- { theme = "mystical" },
	-- { theme = "nocturnal" },
	-- { theme = "ocean" },
	{ theme = "pirate" },
	-- { theme = "retro" },
	-- { theme = "spa" },
	-- { theme = "space" },
	-- { theme = "sports" },
	-- { theme = "stars" },
	-- { theme = "steampunk" },
	-- { theme = "temporal" },
	-- { theme = "thanksgiving" },
	-- { theme = "travel" },
	-- { theme = "tropical" },
	-- { theme = "urban" },
	-- { theme = "wilderness" },
	-- { theme = "wildwest" },
	-- { theme = "winter_wonderland" },
	-- { theme = "zodiac" },
	-- { theme = "zoo" },
}
return {
	"folke/drop.nvim",
	-- enabled = is_enabled_for_today(all_themes),
	enabled = false,
	opts = {
		-- defaults
		---@type DropTheme|string
		theme = "auto", -- when auto, it will choose a theme based on the date
		---@type ({theme: string}|DropDate|{from:DropDate, to:DropDate}|{holiday:"us_thanksgiving"|"easter"})[]
		themes = all_themes,
		max = 75, -- maximum number of drops on the screen
		interval = 100, -- every 150ms we update the drops
		screensaver = 1000 * 60 * 5, -- show after 5 minutes. Set to false, to disable
		filetypes = { "dashboard", "alpha", "ministarter" }, -- will enable/disable automatically for the following filetypes
		-- filetypes = {}, -- will enable/disable automatically for the following filetypes
		winblend = 100, -- winblend for the drop window
	},
}
