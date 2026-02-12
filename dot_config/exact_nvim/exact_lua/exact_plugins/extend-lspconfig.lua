-- Easy config for LSP servers
-- mason.nvim is package manager for LSP servers
-- https://github.com/neovim/nvim-lspconfig
-- JS troubleshooting: https://www.reddit.com/r/neovim/comments/pxcxku/getting_tsserver_to_work_with_javascript_instead/
-- NOTE: `lua =vim.lsp.get_active_clients()[1].name` to get active lsp clients for debugging
-- NOTE: `lua =vim.lsp.get_active_clients()[1].server_capabilities` to show what that client is doing
-- NOTE: Disable watching files globally to see if it causes the slowdown after time
-- local ok, wf = pcall(require, "vim.lsp._watchfiles")
-- if ok then
--     wf._watchfunc = function()
--         return function() end
--     end
-- end
-- Show line diagnostics when cursor rests on line
-- vim.api.nvim_create_autocmd("CursorHold", {
--     callback = function()
--         vim.diagnostic.open_float(nil, {
--             focusable = false,
--             scope = "line",
--             border = "rounded",
--         })
--     end,
-- })

-- Fix: Clean up LspNotify autocmds before vim exits
-- The folding range provider creates LspNotify autocmds that try to access
-- buffers during destruction, causing "Error in LspNotify Autocommands" error on quit.
-- Solution: Remove these autocmds before buffers are destroyed
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    -- Get all autocmds and delete any LspNotify handlers
    -- These will try to access buffers during cleanup and cause errors
    local all_aus = vim.api.nvim_get_autocmds({})
    for _, au in ipairs(all_aus) do
      if au.event == "LspNotify" then
        pcall(vim.api.nvim_del_autocmd, au.id)
      end
    end
  end,
})

-- TODO: Unsure whether this is actually a reasonable solution
-- Fix: Make LSP shutdown instant by wrapping client:stop()
-- The built-in LSP exit handler calls client:stop() which waits ~1 second
-- Combine with VimLeavePre autocmd in `init.lua`
-- Wrap each client's stop method when they attach
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if not client then
--       return
--     end
--
--     -- Wrap this client's stop method to force immediate termination
--     local original_stop = client.stop
--     client.stop = function(self, force)
--       -- Immediately terminate RPC without waiting for graceful shutdown
--       if self.rpc and self.rpc.terminate then
--         pcall(self.rpc.terminate, self.rpc)
--       end
--       -- Call original stop with force=true
--       return original_stop(self, true)
--     end
--   end,
-- })

-- Enable inline completions
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    -- Enable inline completions if supported
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

      vim.keymap.set(
        "i",
        "<C-F>",
        vim.lsp.inline_completion.get,
        { desc = "LSP: accept inline completion", buffer = bufnr }
      )
      vim.keymap.set(
        "i",
        "<C-G>",
        vim.lsp.inline_completion.select,
        { desc = "LSP: switch inline completion", buffer = bufnr }
      )
    end
  end,
})

---@type LazySpec
---@diagnostic disable: missing-fields
return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "mason.nvim",
    { "mason-org/mason-lspconfig.nvim", opts = {} },
    {
      -- Ensure yapf is installed via Mason
      "mason-org/mason.nvim",
      opts = {
        ensure_installed = {
          "bash-language-server",
          "cfn-lint",
          "codelldb",
          "docker-compose-language-service",
          "dockerfile-language-server",
          -- "eslint-lsp",
          "eslint_d",
          "hadolint",
          "jedi-language-server",
          "js-debug-adapter",
          "json-lsp",
          "lua-language-server",
          "markdown-toc",
          "markdownlint-cli2",
          "marksman",
          "nil",
          -- "prettier",
          "prettierd",
          "pylint",
          "pyright",
          -- "ruff",
          -- "ruff-lsp",
          "rust-analyzer",
          "shellcheck",
          "shfmt",
          "stylua",
          -- "taplo",
          "typescript-language-server",
          "vim-language-server",
          -- "yaml-language-server",
          "yapf",
        },
      },
    },
  },
  --     -- FIXME: can't be called as a dependency here, need to figure out how to install since Mason does not have this server
  --     -- {
  --     -- 	"ndonfris/fish-lsp",
  --     -- 	config = function()
  --     -- 		require("lspconfig").fish_lsp.setup({
  --     -- 			filetypes = { "fish" },
  --     -- 		})
  --     -- 	end,
  --     -- },
  --     {
  --         "folke/neoconf.nvim",
  --         -- cmd = "Neoconf",
  --         -- opts = {},
  --         config = function()
  --             require("neoconf").setup()
  --         end,
  --     },
  -- },
  opts = {
    ---@class PluginLspOpts
    -- options for vim.diagnostic.config()
    ---@type vim.diagnostic.Opts
    diagnostics = {
      underline = true,
      update_in_insert = false,
      ---@type vim.diagnostic.Opts.VirtualText
      virtual_text = {
        virt_text_hide = true,
        spacing = 4,
        source = "if_many",
        -- prefix = "●",
        -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        prefix = "icons",
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
    -- NOTE: Code lens causes 40-60% idle CPU usage with no throttling.
    -- Disabled by default - enable manually with :lua vim.lsp.codelens.refresh()
    codelens = {
      enabled = false, -- Disable globally to reduce idle CPU by 40-60%
    },
    -- Enable lsp cursor word highlighting
    document_highlight = {
      enabled = true,
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
    ---@diagnostic disable: missing-fields
    servers = {
      ["*"] = {
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
      },
      copilot = {
        enabled = true,
      },
      yamlls = {
        enabled = true,
        filetypes = { "yaml", "yml" },
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              -- FIXME: CFN schemas not applying
              ["https://s3.amazonaws.com/cfn-resource-specifications-us-east-1-prod/schemas/2.15.0/all-spec.json"] = "/**/cloudFormation/**",
            },
            schemaStore = {
              enable = true,
            },
          },
          codelens = {
            enabled = true,
          },
        },
      },
      taplo = {
        enabled = true,
        filetypes = { "toml", "chezmoitomltmpl" },
        settings = {
          toml = {
            schemaStore = {
              enable = true,
            },
          },
          codelens = {
            enabled = true,
          },
        },
      },
      eslint = {
        enabled = true,
        on_attach = function(client, buffer)
          -- Enable diagnostics virtual text for this buffer
          -- FIX: setting this here throws error on nvim 0.12, perhaps because diagnostics config not initialized yet?
          -- vim.diagnostic.config({ virtual_text = true }, buffer)
          client.server_capabilities.hoverProvider = false
          client.server_capabilities.formattingProvider = true
          client.server_capabilities.documentRangeFormattingProvider = true
          -- FIXME: trying to disable codelens here or below does not seem to work. It only takes effect if done at the global level above.
          client.server_capabilities.codeLensProvider = true
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
          -- vim.api.nvim_create_autocmd("BufWritePre", {
          --     buffer = bufnr,
          --     -- NOTE: This command correctly applies our project-specific ESLint config
          --     command = "EslintFixAll",
          -- })
        end,
        root_dir = require("lspconfig").util.root_pattern("package.json", ".git", "tsconfig.json", "jsconfig.json"), -- search for typescript last
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        settings = {
          javascript = {
            format = {
              enable = true,
              autoformat = true,
            },
          },
          -- FIXME: trying to disable codelens here or above does not seem to work. It only takes effect if done at the global level above.
          codelens = {
            enabled = true,
          },
        },
      },
      tsserver = { enabled = false },
      vtsls = { enabled = true },
      ts_ls = {
        enabled = false,
        on_attach = function(client, buffer)
          client.server_capabilities.hoverProvider = true
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        -- root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"), -- default config
        root_dir = require("lspconfig").util.root_pattern("package.json", ".git", "tsconfig.json", "jsconfig.json"), -- search for typescript last
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
              enable = false,
              autoformat = false,
            },
          },
        },
      },
      pyright = {
        settings = {
          python = {
            workspace = {
              -- diagnosticMode = "openFilesOnly",
              diagnosticMode = "workspace",
            },
            analysis = {
              -- diagnosticMode = "openFilesOnly",
              diagnosticMode = "workspace",
            },
            formatting = {
              provider = "yapf",
            },
          },
          codelens = {
            enabled = true,
          },
        },
        on_attach = function(client, bufnr)
          -- Enable diagnostics virtual text for this buffer
          -- FIX: setting this here throws error on nvim 0.12, perhaps because diagnostics config not initialized yet?
          -- vim.diagnostic.config({ virtual_text = true }, bufnr)
          -- -- Keep Pyright's core capabilities but disable hover since we get that from Jedi
          -- client.server_capabilities.hoverProvider = false
          -- client.server_capabilities.codeLensProvider = false
          client.server_capabilities.hoverProvider = true
          client.server_capabilities.codeLensProvider = true
        end,
      },
      ruff = {
        enabled = false,
      },
      ruff_lsp = {
        enabled = false,
        --     on_attach = function(client, bufnr)
        --         client.server_capabilities.documentFormattingProvider = false
        --         client.server_capabilities.hoverProvider = false
        --     end,
        --     init_options = {
        --         settings = {
        --             args = {},
        --         },
        --     },
      },
      -- ["rust-analyzer"] = {
      --     enabled = true,
      --     on_attach = function(client, bufnr)
      --         -- FIX: This does not solve it, we still get ~/.cargo refs
      --         -- NOTE: This is so that we do not get results in `~/.cargo` when using goto symbol references (<gr>)
      --         local orig = vim.lsp.handlers["textDocument/references"]
      --         vim.lsp.handlers["textDocument/references"] = function(err, result, method, ...)
      --             if not result then
      --                 return orig(err, result, method, ...)
      --             end
      --             local cwd = vim.loop.cwd()
      --             local filtered = vim.tbl_filter(function(item)
      --                 return item.uri:find(cwd, 1, true)
      --             end, result)
      --             return orig(err, filtered, method, ...)
      --         end
      --     end,
      -- },
      jedi_language_server = {
        enabled = false,
        -- settings = {
        --     jedi = {
        --         workspace = {
        --             diagnosticMode = "openFilesOnly",
        --             -- diagnosticMode = "workspace",
        --         },
        --         analysis = {
        --             diagnosticMode = "openFilesOnly",
        --             -- diagnosticMode = "workspace",
        --         },
        --     },
        --     codelens = {
        --         enabled = false,
        --     },
        -- },
        -- on_attach = function(client, buffer)
        --     -- Keep hover enabled for Jedi
        --     client.server_capabilities.hoverProvider = true
        --
        --     -- Disable other capabilities to avoid duplication with Pyright
        --     client.server_capabilities.documentFormattingProvider = false
        --     client.server_capabilities.definitionProvider = false
        --     client.server_capabilities.referencesProvider = false
        --     client.server_capabilities.documentSymbolProvider = false
        --     client.server_capabilities.workspaceSymbolProvider = false
        --     client.server_capabilities.implementationProvider = false
        --     client.server_capabilities.declarationProvider = false
        --     client.server_capabilities.renameProvider = false
        --     client.server_capabilities.codeActionProvider = false
        --     client.server_capabilities.signatureHelpProvider = false
        --     client.server_capabilities.semanticTokensProvider = nil
        --     client.server_capabilities.completionProvider = nil
        --     client.server_capabilities.codeLensProvider = false
        -- end,
      },
      lua_ls = {
        settings = {
          Lua = {
            -- diagnostics = {
            -- NOTE: don't show all missing fields from lazy specs. alternatively add the `---@diagnostic disable: missing-fields` to type defs
            -- 	disable = { "missing-fields" },
            -- },
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
}
