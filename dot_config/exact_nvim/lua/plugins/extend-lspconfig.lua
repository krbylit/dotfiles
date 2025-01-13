-- Easy config for LSP servers
-- mason.nvim is package manager for LSP servers
-- https://github.com/neovim/nvim-lspconfig
-- JS troubleshooting: https://www.reddit.com/r/neovim/comments/pxcxku/getting_tsserver_to_work_with_javascript_instead/
-- NOTE: `lua =vim.lsp.get_active_clients()[1].name` to get active lsp clients for debugging
-- NOTE: `lua =vim.lsp.get_active_clients()[1].server_capabilities` to show what that client is doing

return {
	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {
			"mason.nvim",
			{ "williamboman/mason-lspconfig.nvim", opts = {} },
			{
				-- Ensure yapf is installed via Mason
				"williamboman/mason.nvim",
				opts = {
					ensure_installed = {
						"yapf", -- Install yapf with Mason
						"ruff-lsp",
						"pyright",
						"eslint-lsp",
						"jedi-language-server",
						"lua-language-server",
						"typescript-language-server",
					},
				},
			},
			-- FIXME: can't be called as a dependency here, need to figure out how to install since Mason does not have this server
			-- {
			-- 	"ndonfris/fish-lsp",
			-- 	config = function()
			-- 		require("lspconfig").fish_lsp.setup({
			-- 			filetypes = { "fish" },
			-- 		})
			-- 	end,
			-- },
			{
				"folke/neoconf.nvim",
				-- cmd = "Neoconf",
				-- opts = {},
				config = function()
					require("neoconf").setup()
				end,
			},
		},
		opts = {
			---@class PluginLspOpts
			-- options for vim.diagnostic.config()
			---@type vim.diagnostic.Opts
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					virt_text_hide = false,
					spacing = 4,
					source = "if_many",
					prefix = "●",
					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
					-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
					-- prefix = "icons",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
						[vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
						[vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
						[vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
					},
				},
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				-- enabled = true,
				-- Disable virtual text type hints
				enabled = false,
				exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
			},
			-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the code lenses.
			codelens = {
				enabled = true,
			},
			-- Enable lsp cursor word highlighting
			document_highlight = {
				enabled = true,
			},
			-- add any global capabilities here
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			---@type lspconfig.options
			servers = {
				yamlls = {
					filetypes = { "yaml" },
					settings = {
						yaml = {
							schemaStore = {
								enable = true,
							},
						},
					},
				},
				taplo = {
					filetypes = { "toml", "chezmoitomltmpl" },
					settings = {
						toml = {
							schemaStore = {
								enable = true,
							},
						},
					},
				},
				eslint = {
					on_attach = function(client, buffer)
						client.server_capabilities.hoverProvider = false
						client.server_capabilities.formattingProvider = true
					end,
					settings = {},
				},
				ts_ls = {
					on_attach = function(client, buffer)
						client.server_capabilities.hoverProvider = true
					end,
					-- root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"), -- default config
					root_dir = require("lspconfig").util.root_pattern(
						"package.json",
						".git",
						"tsconfig.json",
						"jsconfig.json"
					), -- search for typescript last
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					settings = {
						-- implicitProjectConfiguration = {
						-- 	checkJs = false, -- NOTE: this seemed to fix the "no ts project" error in JS files, but hopefully the new root_dir fixes it
						-- },
						javascript = {
							suggest = {
								completeFunction = "Icon",
							},
							preferGoToSourceDefinition = true,
							referencesCodeLens = {
								enabled = true,
								showOn = "hover",
								showOnAllFunctions = true,
							},
							codeLens = {
								enable = true,
							},
							format = {
								enable = true,
								autoformat = true,
							},
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								ignore = { "*" },
							},
							formatting = {
								provider = "yapf",
							},
						},
					},
				},
				ruff_lsp = {
					on_attach = function(client, bufnr)
						-- Disable Ruff's formatting capabilities (if enabled by default)
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.hoverProvider = false
					end,
					init_options = {
						-- Configure Ruff-LSP to handle only linting
						settings = {
							args = {},
						},
					},
				},
				jedi_language_server = {
					settings = {
						jedi = {
							workspace = {
								diagnosticMode = "openFilesOnly",
							},
							analysis = {
								diagnosticMode = "openFilesOnly",
							},
						},
					},
					on_attach = function(client, buffer)
						-- Disable formatting since we want from yapf
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.hoverProvider = true
					end,
				},
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},
			},
		},
	},
}
