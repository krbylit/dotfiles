-- Install colorschemes

return {
	-- {
	-- 	-- https://github.com/rebelot/kanagawa.nvim
	-- 	"rebelot/kanagawa.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		compile = false, -- enable compiling the colorscheme
	-- 		undercurl = true, -- enable undercurls
	-- 		commentStyle = { italic = true },
	-- 		functionStyle = {},
	-- 		keywordStyle = { italic = true },
	-- 		statementStyle = { bold = true },
	-- 		typeStyle = {},
	-- 		transparent = false, -- do not set background color
	-- 		dimInactive = false, -- dim inactive window `:h hl-NormalNC`
	-- 		terminalColors = true, -- define vim.g.terminal_color_{0,17}
	-- 		colors = { -- add/modify theme and palette colors
	-- 			palette = {},
	-- 			theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
	-- 		},
	-- 		overrides = function(colors) -- add/modify highlights
	-- 			return {}
	-- 		end,
	-- 		theme = "wave", -- Load "wave" theme when 'background' option is not set
	-- 		background = { -- map the value of 'background' option to a theme
	-- 			dark = "wave", -- try "dragon" !
	-- 			light = "lotus",
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	-- https://github.com/mhartington/oceanic-next
	-- 	"mhartington/oceanic-next",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- },
	-- {
	-- 	-- https://github.com/EdenEast/nightfox.nvim
	-- 	"EdenEast/nightfox.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		-- Compiled file's destination location
	-- 		compile_path = vim.fn.stdpath("cache") .. "/nightfox",
	-- 		compile_file_suffix = "_compiled", -- Compiled file suffix
	-- 		transparent = false, -- Disable setting background
	-- 		terminal_colors = false, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
	-- 		dim_inactive = true, -- Non focused panes set to alternative background
	-- 		module_default = true, -- Default enable value for modules
	-- 		colorblind = {
	-- 			enable = false, -- Enable colorblind support
	-- 			simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
	-- 			severity = {
	-- 				protan = 0, -- Severity [0,1] for protan (red)
	-- 				deutan = 0, -- Severity [0,1] for deutan (green)
	-- 				tritan = 0, -- Severity [0,1] for tritan (blue)
	-- 			},
	-- 		},
	-- 		styles = { -- Style to be applied to different syntax groups
	-- 			comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
	-- 			conditionals = "NONE",
	-- 			constants = "NONE",
	-- 			functions = "NONE",
	-- 			keywords = "NONE",
	-- 			numbers = "NONE",
	-- 			operators = "NONE",
	-- 			strings = "NONE",
	-- 			types = "NONE",
	-- 			variables = "NONE",
	-- 		},
	-- 		inverse = { -- Inverse highlight for different types
	-- 			match_paren = false,
	-- 			visual = false,
	-- 			search = false,
	-- 		},
	-- 		modules = { -- List of various plugins and additional options
	-- 			-- See :help for list of available modules
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	-- https://github.com/scottmckendry/cyberdream.nvim
	-- 	"scottmckendry/cyberdream.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		-- Enable transparent background
	-- 		transparent = true,
	--
	-- 		-- Enable italics comments
	-- 		italic_comments = false,
	--
	-- 		-- Replace all fillchars with ' ' for the ultimate clean look
	-- 		hide_fillchars = false,
	--
	-- 		-- Modern borderless telescope theme
	-- 		borderless_telescope = false,
	--
	-- 		-- Set terminal colors used in `:terminal`
	-- 		terminal_colors = false,
	--
	-- 		-- Use caching to improve performance - WARNING: experimental feature - expect the unexpected!
	-- 		-- Early testing shows a 60-70% improvement in startup time. YMMV. Disables dynamic light/dark theme switching.
	-- 		cache = false, -- generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
	--
	-- 		-- theme = {
	-- 		-- 	variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
	-- 		-- 	highlights = {
	-- 		-- 		-- Highlight groups to override, adding new groups is also possible
	-- 		-- 		-- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values
	-- 		--
	-- 		-- 		-- Example:
	-- 		-- 		Comment = { fg = "#696969", bg = "NONE", italic = true },
	-- 		--
	-- 		-- 		-- Complete list can be found in `lua/cyberdream/theme.lua`
	-- 		-- 	},
	-- 		--
	-- 		-- 	-- Override a highlight group entirely using the color palette
	-- 		-- 	overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
	-- 		-- 		-- Example:
	-- 		-- 		return {
	-- 		-- 			Comment = { fg = colors.green, bg = "NONE", italic = true },
	-- 		-- 			["@property"] = { fg = colors.magenta, bold = true },
	-- 		-- 		}
	-- 		-- 	end,
	-- 		--
	-- 		-- 	-- Override a color entirely
	-- 		-- 	colors = {
	-- 		-- 		-- For a list of colors see `lua/cyberdream/colours.lua`
	-- 		-- 		-- Example:
	-- 		-- 		bg = "#000000",
	-- 		-- 		green = "#00ff00",
	-- 		-- 		magenta = "#ff00ff",
	-- 		-- 	},
	-- 		-- },
	--
	-- 		-- Disable or enable colorscheme extensions
	-- 		-- All available listed here
	-- 		extensions = {
	-- 			alpha = true,
	-- 			cmp = true,
	-- 			dashboard = true,
	-- 			fzflua = true,
	-- 			gitpad = true,
	-- 			gitsigns = true,
	-- 			grapple = true,
	-- 			grugfar = true,
	-- 			heirline = true,
	-- 			hop = true,
	-- 			indentblankline = true,
	-- 			kubectl = true,
	-- 			lazy = true,
	-- 			leap = true,
	-- 			markdown = true,
	-- 			markview = true,
	-- 			mini = true,
	-- 			noice = true,
	-- 			notify = true,
	-- 			rainbow_delimiters = true,
	-- 			telescope = true,
	-- 			treesitter = true,
	-- 			treesittercontext = true,
	-- 			trouble = true,
	-- 			whichkey = true,
	-- 		},
	-- 	},
	-- },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "auto", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "frappe",
				dark = "mocha",
			},
			transparent_background = false, -- disables setting the background color.
			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = true, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.15, -- percentage of the shade to apply to the inactive window
			},
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
			no_underline = false, -- Force no underline
			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
				-- miscs = {}, -- Uncomment to turn off hard-coded styles
			},
			color_overrides = {},
			custom_highlights = {},
			default_integrations = true,
			integrations = {
				blink_cmp = true,
				-- cmp = true,
				dap = true,
				dap_ui = true,
				fzf = true,
				grug_far = true,
				harpoon = true,
				-- gitsigns = true,
				-- nvimtree = true,
				treesitter = true,
				notify = true,
				markdown = true,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					-- underlines = {
					-- 	errors = { "underline" },
					-- 	hints = { "underline" },
					-- 	warnings = { "underline" },
					-- 	information = { "underline" },
					-- 	ok = { "underline" },
					-- },
					inlay_hints = {
						background = true,
					},
				},
				noice = true,
				octo = true,
				overseer = true,
				flash = true,
				render_markdown = true,
				snacks = true,
				telescope = {
					enabled = true,
				},
				lsp_trouble = true,
				treesitter = true,
				which_key = true,
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
			light_style = "day", -- The theme is used when the background is set to light
			transparent = false, -- Enable this to disable setting the background color
			terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
			styles = {
				-- Style to be applied to different syntax groups
				-- Value is any valid attr-list value for `:help nvim_set_hl`
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
				-- Background styles. Can be "dark", "transparent" or "normal"
				sidebars = "dark", -- style for sidebars, see below
				floats = "dark", -- style for floating windows
			},
			sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
			day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
			hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
			dim_inactive = true, -- dims inactive windows
			lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

			--- You can override specific color groups to use other groups or a hex color
			--- function will be called with a ColorScheme table
			---@param colors ColorScheme
			on_colors = function(colors) end,

			--- You can override specific highlights to use other groups or a hex color
			--- function will be called with a Highlights and ColorScheme table
			---@param highlights Highlights
			---@param colors ColorScheme
			on_highlights = function(highlights, colors) end,
			cache = true, -- When set to true, the theme will be cached for better performance
			---@type table<string, boolean|{enabled:boolean}>
			plugins = {
				-- enable all plugins when not using lazy.nvim
				-- set to false to manually enable/disable plugins
				all = package.loaded.lazy == nil,
				-- uses your plugin manager to automatically enable needed plugins
				-- currently only lazy.nvim is supported
				auto = true,
				-- add any plugins here that you want to enable
				-- for all possible plugins, see:
				--   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
				-- telescope = true,
			},
		},
	},
	-- {
	-- 	"Mofiqul/vscode.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		-- Alternatively set style in setup
	-- 		style = "dark",
	--
	-- 		-- Enable transparent background
	-- 		-- transparent = true,
	--
	-- 		-- Enable italic comment
	-- 		italic_comments = true,
	--
	-- 		-- Underline `@markup.link.*` variants
	-- 		underline_links = true,
	--
	-- 		-- Disable nvim-tree background color
	-- 		-- disable_nvimtree_bg = true,
	--
	-- 		-- Override colors (see ./lua/vscode/colors.lua)
	-- 		-- color_overrides = {
	-- 		--     vscLineNumber = "#FFFFFF",
	-- 		-- },
	--
	-- 		-- Override highlight groups (see ./lua/vscode/theme.lua)
	-- 		-- group_overrides = {
	-- 		--     -- this supports the same val table as vim.api.nvim_set_hl
	-- 		--     -- use colors from this colorscheme by requiring vscode.colors!
	-- 		--     Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
	-- 		-- },
	-- 	},
	-- },
	-- {
	-- 	-- https://github.com/sainnhe/everforest
	-- 	"sainnhe/everforest",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.everforest_background = "medium" -- hard, medium, soft
	-- 		vim.g.everforest_enable_italic = 1 -- 0, 1
	-- 		vim.g.everforest_disable_italic_comment = 1 -- 0, 1
	-- 		vim.g.everforest_transparent_background = 0 -- 0, 1
	-- 		vim.g.everforest_dim_inactive_windows = 1 -- 0, 1
	-- 		vim.g.everforest_ui_contrast = "high" -- high, low
	-- 		vim.g.everforest_show_eob = 0 -- 0, 1 show end of buffer
	-- 		vim.g.everforest_float_style = "bright" -- bright, dim style for making floating wins stand out
	-- 		vim.g.everforest_diagnostic_text_highlight = 0 -- 0, 1 highlight diagnostic text in addition to underline
	-- 		vim.g.everforest_current_word = "grey background" -- bold, underline, italic, 'grey background'
	-- 		vim.g.everforest_inlay_hints_background = "dimmed" -- dimmed, none
	-- 		vim.g.everforest_disable_terminal_colors = 0 -- 0, 1
	-- 		vim.g.everforest_better_performance = 1 -- 0, 1 load partial to improve perf
	-- 	end,
	-- },
	{
		"LazyVim/LazyVim",
		opts = {
			-- colorscheme = "everforest",
			colorscheme = "tokyonight",
			-- colorscheme = "catppuccin",
		},
	},
}
