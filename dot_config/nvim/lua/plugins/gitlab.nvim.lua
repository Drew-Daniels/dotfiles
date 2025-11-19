local isMac = function()
	return vim.fn.has("macunix") == 1
end

return {
	"harrisoncramer/gitlab.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
		"nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
	},
	cond = isMac,
	build = function()
		if isMac() then
			-- Builds the Go binary
			require("gitlab.server").build(true)
		end
	end,
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
