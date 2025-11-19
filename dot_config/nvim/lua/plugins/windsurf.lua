-- TODO: Figure out why windsurf fails on NixOS
-- TODO: De-dupe with gitlab.nvim.lua
local isNixOS = function()
	local exit_status = os.execute("command -v nixos-version > /dev/null 2>&1")
	return exit_status == 0
end

local isNotNixOS = function()
	return not isNixOS()
end

return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	cond = isNotNixOS(),
	config = function()
		require("codeium").setup({
			enable_chat = true,
			virtual_text = {
				enabled = true,
				-- Require windsurf to be manually enabled for virtual text
				manual = true,
				-- enable virtualtext for all filetypes by default
				default_filetype_enabled = true,
				-- explicitly disable virtual text for some filetypes
				filetypes = {
					norg = false,
					text = false,
					markdown = false,
				},
				key_bindings = {
					accept = "<C-g>",
					clear = "<C-x>",
				},
			},
		})
	end,
}
