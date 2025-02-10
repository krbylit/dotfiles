-- QoL mini-plugins
-- https://github.com/folke/snacks.nvim
-- FIXME: disabling for now because `notifier` having odd behavior: not responding to disabling it, doesn't play with my current telescope extension to search previous notis
local function get_terminal_size()
	local width = vim.api.nvim_get_option("columns") -- Get terminal width
	local height = vim.api.nvim_get_option("lines") -- Get terminal height
	return width, height
end
local terminal_width, terminal_height = get_terminal_size()
local logo_file = require("misc.dash-helpers").random_logo_file()
local measure_logo_file = require("misc.dash-helpers").measure_logo_file
local logo_width, logo_height = measure_logo_file(logo_file)
local pane_width = math.floor(terminal_width / 4)

local picker = require("snacks.picker")

---@diagnostic disable: missing-fields
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		---@type snacks.win.Config
		styles = {
			notification = {
				wo = { wrap = true }, -- Wrap notifications
			},
			lazygit = {
				-- Make lazygit fullscreen
				height = 0,
				width = 0,
			},
		},
		bigfile = { enabled = true },
		input = { enabled = true },
		---@type snacks.lazygit.Config: snacks.terminal.Opts
		lazygit = { enabled = true },
		notifier = {
			style = "fancy", -- "compact" | "minimal" | "fancy"
			enabled = true, -- Disabling for now because <leader>un not working to view all notis
			timeout = 3000,
		},
		quickfile = {},
		scroll = { enabled = true },
		scope = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		---@type snacks.zen.Config
		zen = {
			enabled = true,
			toggles = {
				diagnostics = false,
				inlay_hints = false,
			},
		},
		---@type snacks.picker.Config
		picker = {
			-- ---@type snacks.picker.matcher.Config
			-- matcher = {},
			---@type snacks.picker.sources.Config
			win = {
				-- input window
				input = {
					keys = {
						-- Make <C-c> close in normal as well as insert mode
						["<C-c>"] = { "close", mode = { "i", "n" } },
						["<a-w>"] = { "toggle_cwd", mode = { "n", "i" } },
						["<C-p>"] = { "focus_preview", mode = { "i", "n" } }, -- or any other key you prefer
						["<C-i>"] = { "focus_input", mode = { "i", "n" } }, -- or any other key you prefer
						["<C-l>"] = { "focus_list", mode = { "i", "n" } }, -- or any other key you prefer
					},
				},
				-- result list window
				list = {
					keys = {
						-- Make <C-c> close in normal as well as insert mode
						["<C-c>"] = { "close", mode = { "i", "n" } },
						["<C-p>"] = { "focus_preview", mode = { "i", "n" } }, -- or any other key you prefer
						["<C-i>"] = { "focus_input", mode = { "i", "n" } }, -- or any other key you prefer
						["<C-l>"] = { "focus_list", mode = { "i", "n" } }, -- or any other key you prefer
					},
				},
				-- preview window
				preview = {
					keys = {
						-- Make <C-c> close in normal as well as insert mode
						["<C-c>"] = { "close", mode = { "i", "n" } },
						["<C-p>"] = { "focus_preview", mode = { "i", "n" } }, -- or any other key you prefer
						["<C-i>"] = { "focus_input", mode = { "i", "n" } }, -- or any other key you prefer
						["<C-l>"] = { "focus_list", mode = { "i", "n" } }, -- or any other key you prefer
					},
				},
			},
			---@type snacks.picker.sources.Config
			sources = {
				-- ---@type snacks.picker.notifications.Config: snacks.picker.Config
				-- ---@field filter? snacks.notifier.level|fun(notif: snacks.notifier.Notif): boolean
				-- notifications = {},
				---@type snacks.picker.files.Config: snacks.picker.proc.Config
				files = {
					hidden = false,
					ignored = false,
					-- Exclude dirs from file search
					exclude = {
						"**/.venv/**",
						"**/venv/**",
						"**/virtual_env/**",
						"**/node_modules/**",
						"**/dist/**",
						"**/build/**",
						"**/__pycache__/**",
					},
				},
				---@type snacks.picker.grep.Config
				grep = {
					hidden = false,
					ignored = false,
					-- Exclude dirs from text search
					exclude = {
						"**/.venv/**",
						"**/venv/**",
						"**/virtual_env/**",
						"**/node_modules/**",
						"**/dist/**",
						"**/build/**",
						"**/__pycache__/**",
					},
				},
				---@type snacks.picker.lsp.Config
				lsp_declarations = {},
				---@type snacks.picker.lsp.Config
				lsp_definitions = {},
				---@type snacks.picker.lsp.Config
				lsp_implementations = {},
				---@type snacks.picker.lsp.Config
				lsp_references = {},
				---@type snacks.picker.lsp.Config
				lsp_symbols = {},
				---@type snacks.picker.lsp.Config
				lsp_type_definitions = {},
			},
			---@type snacks.picker.layout.Config
			layout = {
				preset = "ivy",
				reverse = false,
			},
			---@type snacks.picker.formatters.Config
			formatters = {
				file = {
					filename_first = true,
				},
			},
		},
		---@type snacks.dashboard.Config
		dashboard = {
			enabled = true,
			-- height = terminal_height,
			-- width = terminal_width,
			-- row = 1,
			-- col = 1,
			pane_gap = 4,
			sections = {
				{
					pane = 1,
					section = "terminal",
					-- cmd = 'cat "' .. logo_file .. '" | lolcat -a -d 2 -s 15 -F 0.3 -t -p 100 -f',
					cmd = 'bash -c "for i in {1..10}; do clear; cat "'
						.. logo_file
						.. '" | lolcat -a -d 4 -s 15 -F 0.3 -t -p 100 -f; sleep 4; done"',
					height = logo_height,
					width = logo_width,
					-- height = math.floor(terminal_height / 3),
					-- width = terminal_width,
					-- indent = indent,
					-- random = 100,
					padding = 2,
					ttl = 0, -- cmd is cached by snacks, so upping random or setting ttl to 0 makes it refresh on every load
				},
				{
					pane = 2,
					height = logo_height,
					padding = logo_height + 1,
				},
				{
					pane = 3,
					height = logo_height,
					padding = logo_height + 1,
				},
				{ icon = " ", pane = 2, title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{
					pane = 3,
					icon = " ",
					title = "Git Status",
					-- cmd = "hub --no-pager diff --stat -B -M -C",
					-- cmd = "hub status --short --branch --renames",
					cmd = "git rev-parse --is-inside-work-tree >/dev/null 2>&1 && hub status --short --branch --renames || true",
					section = "terminal",
					height = 10,
					ttl = 0,
				},
				{
					pane = 2,
					section = "startup",
				},
			},
		},
		---@type snacks.indent
		indent = {
			---@type snacks.indent.Config
			indent = {
				enabled = false, -- enable indent guides
				char = "│",
				blank = " ",
				-- blank = "∙",
				only_scope = true, -- only show indent guides of the scope
				only_current = true, -- only show indent guides in the current window
				-- hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
				-- can be a list of hl groups to cycle through
				hl = {
					"SnacksIndent1",
					"SnacksIndent2",
					"SnacksIndent3",
					"SnacksIndent4",
					"SnacksIndent5",
					"SnacksIndent6",
					"SnacksIndent7",
					"SnacksIndent8",
				},
			},
			---@type snacks.indent.animate
			animate = {
				enabled = vim.fn.has("nvim-0.10") == 1,
				easing = "linear",
				duration = {
					step = 20, -- ms per step
					total = 500, -- maximum duration
				},
			},
			---@type snacks.indent.Scope.Config: snacks.scope.Config
			scope = {
				enabled = true, -- enable highlighting the current scope
				char = "│",
				underline = false, -- underline the start of the scope
				only_current = true, -- only show scope in the current window
				hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
			},
			chunk = {
				-- when enabled, scopes will be rendered as chunks, except for the
				-- top-level scope which will be rendered as a scope.
				enabled = true,
				-- only show chunk scopes in the current window
				only_current = true,
				hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
				char = {
					corner_top = "┌",
					corner_bottom = "└",
					-- corner_top = "╭",
					-- corner_bottom = "╰",
					horizontal = "─",
					vertical = "│",
					arrow = ">",
					-- arrow = "─",
				},
			},
			blank = {
				char = " ",
				-- char = "·",
				hl = "SnacksIndentBlank", ---@type string|string[] hl group for blank spaces
			},
			-- filter for buffers to enable indent guides
			filter = function(buf)
				return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
			end,
			priority = 200,
		},
		profiler = {
			opts = function(_, opts)
				---@type snacks.profiler.Config
				opts = vim.tbl_deep_extend("force", opts or {}, {
					-- Toggle the profiler
					-- Snacks.toggle.profiler():map("<leader>pp"),
					-- -- Toggle the profiler highlights
					-- Snacks.toggle.profiler_highlights():map("<leader>ph"),
					autocmds = true,
					runtime = vim.env.VIMRUNTIME, ---@type string
					-- thresholds for buttons to be shown as info, warn or error
					-- value is a tuple of [warn, error]
					thresholds = {
						time = { 2, 10 },
						pct = { 10, 20 },
						count = { 10, 100 },
					},
					on_stop = {
						highlights = true, -- highlight entries after stopping the profiler
						pick = true, -- show a picker after stopping the profiler (uses the `on_stop` preset)
					},
					---@type snacks.profiler.Highlights
					highlights = {
						min_time = 0, -- only highlight entries with time > min_time (in ms)
						max_shade = 20, -- time in ms for the darkest shade
						badges = { "time", "pct", "count", "trace" },
						align = 80,
					},
					pick = {
						picker = "snacks", ---@type snacks.profiler.Picker
						---@type snacks.profiler.Badge.type[]
						badges = { "time", "count", "name" },
						---@type snacks.profiler.Highlights
						preview = {
							badges = { "time", "pct", "count" },
							align = "right",
						},
					},
					startup = {
						event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
						after = true, -- stop the profiler **after** the event. When false it stops **at** the event
						pattern = nil, -- pattern to match for the autocmd
						pick = true, -- show a picker after starting the profiler (uses the `startup` preset)
					},
					---@type table<string, snacks.profiler.Pick|fun():snacks.profiler.Pick?>
					presets = {
						startup = { min_time = 1, sort = false },
						on_stop = {},
						filter_by_plugin = function()
							return { filter = { def_plugin = vim.fn.input("Filter by plugin: ") } }
						end,
					},
					---@type string[]
					globals = {
						-- "vim",
						-- "vim.api",
						-- "vim.keymap",
						-- "Snacks.dashboard.Dashboard",
					},
					-- filter modules by pattern.
					-- longest patterns are matched first
					filter_mod = {
						default = true, -- default value for unmatched patterns
						["^vim%."] = false,
						["mason-core.functional"] = false,
						["mason-core.functional.data"] = false,
						["mason-core.optional"] = false,
						["which-key.state"] = false,
					},
					filter_fn = {
						default = true,
						["^.*%._[^%.]*$"] = false,
						["trouble.filter.is"] = false,
						["trouble.item.__index"] = false,
						["which-key.node.__index"] = false,
						["smear_cursor.draw.wo"] = false,
						["^ibl%.utils%."] = false,
					},
					icons = {
						time = " ",
						pct = " ",
						count = " ",
						require = "󰋺 ",
						modname = "󰆼 ",
						plugin = " ",
						autocmd = "⚡",
						file = " ",
						fn = "󰊕 ",
						status = "󰈸 ",
					},
				})
			end,
		},
	},
	keys = {
		{
			"<leader>z",
			function()
				Snacks.picker.zoxide()
			end,
			desc = "Zoxide",
		},
		-- {
		-- 	-- FIXME: conflicting with yanky keymap
		-- 	"<leader>ps",
		-- 	function()
		-- 		Snacks.profiler.scratch()
		-- 	end,
		-- 	desc = "Profiler Scratch Bufer",
		-- },
	},
}
