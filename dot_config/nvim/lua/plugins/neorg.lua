return {
	"nvim-neorg/neorg",
	dependencies = { "luarocks.nvim" },
	lazy = false,
	version = "*",
	cond = false,
	opts = {
		load = {
			["core.defaults"] = {},
			["core.concealer"] = {},
			["core.dirman"] = {
				config = {
					workspaces = {
						su = "~/projects/work_notes/su/2024",
						ooo = "~/projects/work_notes/ooo/2024",
					},
				},
			},
			["core.keybinds"] = {},
			["core.export"] = {},
			-- NOTE: API likely to be changed soon: https://github.com/nvim-neorg/neorg/wiki/Core-Presenter#overview
			-- ["core.presenter"] = {
			--   config = {
			--     zen_mode = "zen-mode",
			--   },
			-- },
			["core.summary"] = {},
			["core.text-objects"] = {},
		},
	},
}
