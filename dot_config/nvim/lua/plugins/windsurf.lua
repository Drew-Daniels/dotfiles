return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	cond = false,
	-- cond = function()
	-- 	-- Only run on macos
	-- 	return vim.fn.has("macunix") == 1
	-- end,
	config = function()
		require("codeium").setup({
			enable_chat = true,
			virtual_text = {
				enabled = true,
				-- If I want to be in control of when completions are displayed
				-- manual = true,
				filetypes = {
					-- explicitly specify which filetypes I want to enable/disable virtual text for
					norg = false,
					text = false,
				},
				-- default to enabling for the rest
				default_filetype_enabled = true,
				key_bindings = {
					accept = "<C-g>",
					clear = "<C-x>",
				},
			},
		})
	end,
}
