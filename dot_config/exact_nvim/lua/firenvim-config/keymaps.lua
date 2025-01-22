local M = {}

M.setup = function()
	local map = vim.keymap.set
	local wk = require("which-key")

	map({ "n", "v", "i" }, "<c-s>", "<cmd>wqa!<cr>", { noremap = true, silent = true })
end

return M
