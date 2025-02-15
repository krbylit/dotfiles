-- Displays git graphs
-- https://github.com/isakbm/gitgraph.nvim
return {
	"isakbm/gitgraph.nvim",
	-- dependencies = { "sindrets/diffview.nvim" },
	opts = {
		symbols = {
			merge_commit = "M",
			commit = "*",
		},
		format = {
			timestamp = "%H:%M:%S %d-%m-%Y",
			fields = { "hash", "timestamp", "author", "branch_name", "tag" },
		},
		-- open commits in diffview.nvim
		-- hooks = {
		-- 	-- Check diff of a commit
		-- 	on_select_commit = function(commit)
		-- 		vim.notify("DiffviewOpen " .. commit.hash .. "^!")
		-- 		vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
		-- 	end,
		-- 	-- Check diff from commit a -> commit b
		-- 	on_select_range_commit = function(from, to)
		-- 		vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
		-- 		vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
		-- 	end,
		-- },
		hooks = {
			on_select_commit = function(commit)
				print("selected commit:", commit.hash)
			end,
			on_select_range_commit = function(from, to)
				print("selected range:", from.hash, to.hash)
			end,
		},
	},
	keys = {
		{
			"<leader>gl",
			function()
				require("gitgraph").draw({}, { all = true, max_count = 5000 })
			end,
			desc = "GitGraph - Draw",
		},
	},
}
