-- Copilot chat plugin for in-editor chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

-- -- require("CopilotChat.integrations.cmp").setup()
-- require("CopilotChat").setup({
-- 	mappings = {
-- 		complete = {
-- 			insert = "",
-- 		},
-- 	},
-- 	-- rest of your config
-- })
-- -- Registers copilot-chat filetype for markdown rendering
-- require("render-markdown").setup({
-- 	file_types = { "markdown", "copilot-chat" },
-- })
--
-- -- You might also want to disable default header highlighting for copilot chat when doing this
-- require("CopilotChat").setup({
-- 	highlight_headers = false,
-- 	-- rest of your config
-- })
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  enabled = false,
  dependencies = {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  opts = {
    model = "claude-sonnet-4",
  },
}
