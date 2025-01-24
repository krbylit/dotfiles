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
						"prettierd",
						"eslint_d",
						"bash-language-server",
						"docker-compose-language-service",
						"dockerfile-language-server",
						"eslint-lsp",
						"hadolint",
						"jedi-language-server",
						"js-debug-adapter",
						"json-lsp",
						"lua-language-server",
						"markdown-toc",
						"markdownlint-cli2",
						"marksman",
						"nil",
						"prettier",
						"pyright",
						"ruff",
						"ruff-lsp",
						"shellcheck",
						"shfmt",
						"stylua",
						"taplo",
						"typescript-language-server",
						-- "vtsls",
						"yaml-language-server",
						"yapf",
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
						client.server_capabilities.documentRangeFormattingProvider = true
						-- NOTE: autocmd for debugging. On save, prints all the formatters that ran
						-- vim.api.nvim_create_autocmd("BufWritePre", {
						-- 	callback = function()
						-- 		local clients = vim.lsp.get_active_clients({ bufnr = 0 })
						-- 		for _, client in ipairs(clients) do
						-- 			if client.supports_method("textDocument/formatting") then
						-- 				print("Formatter:", client.name)
						-- 			end
						-- 		end
						-- 	end,
						-- })
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							-- NOTE: This command correctly applies our project-specific ESLint config
							command = "EslintFixAll",
						})
					end,
					settings = {},
				},
				ts_ls = {
					on_attach = function(client, buffer)
						client.server_capabilities.hoverProvider = true
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
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
					on_attach = function(client, bufnr)
						-- Keep Pyright's core capabilities but disable hover
						client.server_capabilities.hoverProvider = false
					end,
				},
				ruff_lsp = {
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.hoverProvider = false
					end,
					init_options = {
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
						-- Disable formatting since we want it from yapf
						client.server_capabilities.documentFormattingProvider = false

						-- Keep hover enabled for Jedi
						client.server_capabilities.hoverProvider = true

						-- Disable other capabilities to avoid duplication with Pyright
						client.server_capabilities.definitionProvider = false
						client.server_capabilities.referencesProvider = false
						client.server_capabilities.documentSymbolProvider = false
						client.server_capabilities.workspaceSymbolProvider = false
						client.server_capabilities.implementationProvider = false
						client.server_capabilities.declarationProvider = false
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
