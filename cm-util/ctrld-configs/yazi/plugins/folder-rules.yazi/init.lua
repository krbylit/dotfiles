-- This plugin can be used to provide directory-specific rules for Yazi.
-- Sort "Downloads" dir by modified
local function setup()
	ps.sub("cd", function()
		local cwd = cx.active.current.cwd
		if cwd:ends_with("Downloads") then
			ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
		else
			ya.manager_emit("sort", { "natural", reverse = false, dir_first = true })
		end
	end)
end

return { setup = setup }
