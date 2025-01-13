local cmp = require("cmp")
-- local blink = require("blink.cmp")
-- local cmp_active = true
-- local function toggle_cmp(enable)
-- 	if enable then
-- 		cmp_active = true
-- 		blink.setup({
-- 			completion = {
-- 				menu = { enabled = true },
-- 			},
-- 		})
-- 	else
-- 		cmp_active = false
-- 		blink.setup({
-- 			completion = {
-- 				menu = { enabled = false },
-- 			},
-- 	end
-- end
--
-- -- Re-enable cmp when entering insert mode
-- vim.api.nvim_create_autocmd("InsertEnter", {
-- 	callback = function()
-- 		-- "try" to swallow error when not normal buffer (e.g. TelescopePrompt etc.)
-- 		pcall(function()
-- 			toggle_cmp(true)
-- 		end)
-- 		-- end
-- 	end,
-- })
return {
	"saghen/blink.cmp",
	dependencies = {
		-- NOTE: necessary here otherwise copilot shows up in LazyVim as disabled, possibly a LazyVim bug
		{ "zbirenbaum/copilot.lua", enabled = true, opts = {} },
		{
			"hrsh7th/cmp-cmdline",
			config = function()
				-- Completion on buffer search
				-- `/` cmdline setup.
				cmp.setup.cmdline("/", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = "buffer" },
					},
				})
				-- Completion on nvim command line
				-- `:` cmdline setup.
				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						-- { name = "neorg" },
						{ name = "path" },
					}, {
						{
							name = "cmdline",
							option = {
								ignore_cmds = { "Man", "!" },
							},
						},
					}),
				})
			end,
		},
		-- {
		-- 	"hrsh7th/nvim-cmp",
		-- 	enabled = true,
		-- 	opts = {},
		-- 	dependencies = {
		-- 		"hrsh7th/cmp-cmdline",
		-- 		config = function()
		-- 			-- Completion on buffer search
		-- 			-- `/` cmdline setup.
		-- 			cmp.setup.cmdline("/", {
		-- 				mapping = cmp.mapping.preset.cmdline(),
		-- 				sources = {
		-- 					{ name = "buffer" },
		-- 				},
		-- 			})
		-- 			-- Completion on nvim command line
		-- 			-- `:` cmdline setup.
		-- 			cmp.setup.cmdline(":", {
		-- 				mapping = cmp.mapping.preset.cmdline(),
		-- 				sources = cmp.config.sources({
		-- 					-- { name = "neorg" },
		-- 					{ name = "path" },
		-- 				}, {
		-- 					{
		-- 						name = "cmdline",
		-- 						option = {
		-- 							ignore_cmds = { "Man", "!" },
		-- 						},
		-- 					},
		-- 				}),
		-- 			})
		-- 		end,
		-- 	},
		-- },
	},
	--- @type blink.cmp.ConfigStrict
	opts = {
		-- --- @type blink.cmp.AppearanceConfig,
		-- appearance = {},
		-- --- @type blink.cmp.FuzzyConfig,
		-- fuzzy = {},
		-- --- @type blink.cmp.SignatureConfig,
		-- signature = {},
		-- --- @type blink.cmp.SnippetsConfig,
		-- snippets = {},
		--- @type blink.cmp.CompletionConfig,
		completion = {
			ghost_text = {
				enabled = true,
			},
		},
		--- @type blink.cmp.SourceConfig
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "copilot", "cmdline" },
			-- cmdline = {},
			-- compat = {},
			--- @type blink.cmp.SourceProviderConfig
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-cmp-copilot",
					kind = "Copilot",
					score_offset = 999, -- Boost Copilot's score (adjust as needed) so it comes first
				},
			},
		},
		--- @type blink.cmp.KeymapConfig,
		keymap = {
			preset = "default",
			["<C-y>"] = { "accept", "fallback" },
			-- ["<C-i>"] = { "hide", "fallback" },
		},
	},
}
