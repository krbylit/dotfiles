return {
	"ibhagwan/fzf-lua",
	opts = {
		winopts = {
			split = "belowright new",
			-- preview = {
			-- hidden = "hidden", -- Start with the preview hidden
			-- layout = "flex", -- Optional: auto layout preview
			-- },
		},
		files = {
			-- find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
			rg_opts = [[--color=never --files --hidden --follow --pcre2 -g "!**/.git/**" -g "!**/node_modules/**" -g "!**/dist/**" -g "!**/build/**"]],
			fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude dist --exclude build]],
			cwd_prompt = true,
			cwd_prompt_shorten_len = 32, -- shorten prompt beyond this length
			cwd_prompt_shorten_val = 1, -- shortened path parts length
		},
		grep = {
			rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --pcre2 --glob=!**/node_modules/** --glob=!**/.git/** --glob=!**/dist/** --glob=!**/build/** --glob=!**/package-lock.json",
			-- Set to 'true' to always parse globs in both 'grep' and 'live_grep'
			-- search strings will be split using the 'glob_separator' and translated
			-- to '--iglob=' arguments, requires 'rg'
			-- can still be used when 'false' by calling 'live_grep_glob' directly
			rg_glob = true, -- default to glob parsing?
			glob_flag = "--iglob", -- for case sensitive globs use '--glob'
			glob_separator = "%s%-%-", -- query separator pattern (lua): ' --' e.g. `search term -- !build/*` to search excluding build/ dir etc.
		},
		keymap = {
			builtin = {
				true,
				["<c-p>"] = "toggle-preview",
			},
		},
	},
	-- NOTE: not needed as we set globbing in opts above
	-- keys = {
	-- 	{ "<leader>/", LazyVim.pick("live_grep_glob"), desc = "Grep (Root Dir)" },
	-- 	{ "<leader>sg", LazyVim.pick("live_grep_glob"), desc = "Grep (Root Dir)" },
	-- 	{ "<leader>sG", LazyVim.pick("live_grep_glob", { root = false }), desc = "Grep (cwd)" },
	-- },
}
