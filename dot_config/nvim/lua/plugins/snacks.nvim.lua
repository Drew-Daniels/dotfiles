return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	---@type snacks.Config
	opts = {
		image = {
			env = {
				SNACKS_GHOSTTY = true,
			},
			resolve = function(path, src)
				if require("obsidian.api").path_is_note(path) then
					return require("obsidian.api").resolve_image_path(src)
				end
			end,
		},
		notifier = {
			style = "compact",
		},
		input = {},
		scroll = {
			animate = {
				easing = "inOutQuad",
			},
		},
		indent = {},
	},
}
