-- REPL for neovim, can interact with the neovim API
-- https://github.com/ii14/neorepl.nvim

return {
	-- "ii14/neorepl.nvim",
	-- lazy = true,
	-- config = function()
	-- 	vim.keymap.set("n", "<leader>r", function()
	-- 		-- get current buffer and window
	-- 		local buf = vim.api.nvim_get_current_buf()
	-- 		local win = vim.api.nvim_get_current_win()
	-- 		-- create a new split for the repl
	-- 		vim.cmd("split")
	-- 		-- spawn repl and set the context to our buffer
	-- 		require("neorepl").new({
	-- 			lang = "lua",
	-- 			buffer = buf,
	-- 			window = win,
	-- 		})
	-- 		-- resize repl window and make it fixed height
	-- 		vim.cmd("resize 10 | setl winfixheight")
	-- 	end)
	-- end,
}
