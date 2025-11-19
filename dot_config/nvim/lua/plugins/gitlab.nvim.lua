-- TODO: Move somewhere where I can easily reuse
local isMac = function()
	return vim.fn.has("macunix") == 1
end

local isNixOS = function()
	local exit_status = os.execute("command -v nixos-version > /dev/null 2>&1")
	return exit_status == 0
end

local isNotNixOS = function()
	return not isNixOS()
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
	cond = isNotNixOS(),
	build = function()
		if isNotNixOS() then
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
