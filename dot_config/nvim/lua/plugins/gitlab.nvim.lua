return {
	"harrisoncramer/gitlab.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
		"nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
	},
	build = function()
		require("gitlab.server").build(true)
	end, -- Builds the Go binary
	-- TODO: Use `opts` instead of manually calling `setup`
	config = function()
		require("gitlab").setup({
			create_mr = {
				target = "main",
				template_file = "Default.md",
				squash = true,
			},
		})
	end,
}
