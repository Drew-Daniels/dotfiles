return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	cond = false,
	init = function()
		-- TODO: Should these go in 'config' function instead? Since these should only be set whenever
		-- the plugin is used
		vim.g.codeium_disable_bindings = 1
		vim.g.codeium_no_map_tab = 1
		vim.g.codeium_os = "Darwin"
		vim.g.codeium_arch = "arm"
		vim.cmd([[
      let g:codeium_filetypes = {
        \ "norg": v:false,
        \ "text": v:false,
        \ }
    ]])
	end,
	config = function()
		require("codeium").setup({})
	end,
}
