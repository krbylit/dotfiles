-- Formatter
-- https://github.com/stevearc/conform.nvim
return {
	"stevearc/conform.nvim",
	opts = {
		default_format_opts = {
			timeout_ms = 3000,
			async = false, -- not recommended to change
			quiet = false, -- not recommended to change
			lsp_format = "fallback", -- not recommended to change
		},
		formatters_by_ft = {
			lua = { "stylua" },
			fish = { "fish_indent" },
			sh = { "shfmt" },
			javascript = { "eslint_d", "prettierd" },
			typescript = { "eslint_d", "prettierd" },
			javascriptreact = { "eslint_d", "prettierd" },
			typescriptreact = { "eslint_d", "prettierd" },
			json = { "prettierd" },
			python = { "yapf" },
		},
		-- The options you set here will be merged with the builtin formatters.
		-- You can also define any custom formatters here.
		---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
		formatters = {
			injected = { options = { ignore_errors = true } },
		},
	},
}
