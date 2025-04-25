-- While debugging, change `K` hover to nvim-dap widget to show var evaluation.
local dap = require("dap")
local api = vim.api
local keymap_restore = {}

dap.listeners.after["event_initialized"]["dapKeyOverride"] = function()
	keymap_restore = {} -- Clear previous mappings
	for _, buf in pairs(api.nvim_list_bufs()) do
		local keymaps = api.nvim_buf_get_keymap(buf, "n")
		for _, keymap in pairs(keymaps) do
			if keymap.lhs == "K" then
				table.insert(keymap_restore, keymap)
				api.nvim_buf_del_keymap(buf, "n", "K")
			end
		end
		api.nvim_buf_set_keymap(buf, "n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
	end
end

dap.listeners.after["event_terminated"]["dapKeyOverride"] = function()
	for _, keymap in pairs(keymap_restore) do
		if keymap.rhs then
			-- Restore normal keymap
			api.nvim_buf_set_keymap(
				keymap.buffer,
				keymap.mode,
				keymap.lhs,
				keymap.rhs,
				{ silent = keymap.silent == 1, noremap = keymap.noremap == 1, expr = keymap.expr == 1 }
			)
		elseif keymap.callback then
			-- Restore keymap with callback
			vim.keymap.set(keymap.mode, keymap.lhs, keymap.callback, {
				buffer = keymap.buffer,
				silent = keymap.silent == 1,
				noremap = keymap.noremap == 1,
				expr = keymap.expr == 1,
			})
		else
			vim.notify("DAP Key Override: Missing rhs or callback for keymap " .. keymap.lhs, vim.log.levels.WARN)
		end
	end
	keymap_restore = {} -- Reset keymap storage
end
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- {
		-- NOTE: Minimal dap UI, but seems to currently have a config bug. Can try enabling this later.
		-- 	"igorlfs/nvim-dap-view",
		-- opts = {
		-- 	winbar = {
		-- 		show = true,
		-- 		sections = { "watches", "exceptions", "breakpoints", "repl" },
		-- 		-- Must be one of the sections declared above
		-- 		default_section = "watches",
		-- 	},
		-- 	windows = {
		-- 		height = 12,
		-- 	},
		-- },
		-- },
		-- { "rcarriga/nvim-dap-ui", enabled = false },
	},
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Start/Continue",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<F12>",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
		{
			"<F9>",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<F8>",
			function()
				require("dap").terminate()
			end,
			desc = "Terminate",
		},
		{
			"<F6>",
			function()
				require("dap").pause()
			end,
			desc = "Pause",
		},
	},
}
