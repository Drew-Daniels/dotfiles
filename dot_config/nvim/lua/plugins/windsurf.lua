return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	-- Only run on macos
	cond = function()
		return vim.fn.has("macunix") == 1
	end,
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
		vim.keymap.set("i", "<C-g>", function()
			return vim.fn["codeium#Accept"]()
		end, { expr = true, silent = true, desc = "Codeium Accept" })

		vim.keymap.set("i", "<C-x>", function()
			return vim.fn["codeium#Clear"]()
		end, { expr = true, silent = true, desc = "Codeium Clear" })
	end,
}
