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
	-- init = function()
	-- 	-- TODO: Should these go in 'config' function instead? Since these should only be set whenever
	-- 	-- the plugin is used
	-- 	vim.g.codeium_disable_bindings = 1
	-- 	vim.g.codeium_no_map_tab = 1
	-- 	vim.g.codeium_os = "Darwin"
	-- 	vim.g.codeium_arch = "arm"
	-- 	vim.cmd([[
	--      let g:codeium_filetypes = {
	--        \ "norg": v:false,
	--        \ "text": v:false,
	--        \ }
	--    ]])
	-- end,
	opts = {
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
	},
	config = function()
		require("codeium").setup({})
		-- defaults: https://github.com/Exafunction/codeium.vim?tab=readme-ov-file#%EF%B8%8F-keybindings
		-- set the Meta key in iTerm2 > Preferences > Profiles > Keys > Left Option Key to Esc+
		vim.keymap.set("i", "<C-g>", function()
			return vim.fn["codeium#Accept"]()
		end, { expr = true, silent = true, desc = "Codeium Accept" })

		vim.keymap.set("i", "<C-x>", function()
			return vim.fn["codeium#Clear"]()
		end, { expr = true, silent = true, desc = "Codeium Clear" })
	end,
}
