return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		image = {
			-- force = true,
			env = {
				SNACKS_GHOSTTY = true,
			},
			resolve = function(path, src)
				if require("obsidian.api").path_is_note(path) then
					return require("obsidian.api").resolve_image_path(src)
				end
			end,
		},
	},
}
