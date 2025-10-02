local IS_DARK_MODE = os.getenv("OS_THEME_DARK") == "1"
-- local THEME = IS_DARK_MODE and "gruvbox-material" or "gruvbox_light"
local THEME = IS_DARK_MODE and "gruvbox-material" or "catppuccin"

local function getCodeiumStatus()
	return "codeium: " .. vim.fn["codeium#GetStatusString"]()
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
	opts = {
		options = { theme = THEME },
		-- options = { theme = "zenbones" },
		sections = {
			lualine_x = {
				"grapple",
				getCodeiumStatus,
			},
		},
	},
}
