return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		-- VimTeX configuration goes here, e.g.
		vim.g.vimtex_view_method = "zathura"
		-- silence warning that tree-sitter is being used for syntax highlighting
		vim.g.vimtex_syntax_enabled = 0
		-- NOTE: 'latexmk' is included with texlive by default, and supports automatic re-compilation upon changes
		-- NOTE: 'tectonic' is a faster alternative to texlive, but requires manual re-compilation
		vim.g.vimtex_compiler_method = "latexmk"
		-- vim.g.vimtex_compiler_method = "tectonic"
		-- NOTE: 'tectonic' defaults below
		-- vim.g.vimtex_compiler_tectonic = {
		-- 	out_dir = "",
		-- 	hooks = {},
		-- 	options = {
		-- 		"--keep-logs",
		-- 		"--synctex",
		-- 	},
		-- }
		-- NOTE: 'latexmk' defaults below
		-- vim.g.vimtex_compiler_latexmk = {
		-- 	aux_dir = "",
		-- 	out_dir = "",
		-- 	callback = 1,
		-- 	continuous = 1,
		-- 	executable = "latexmk",
		-- 	hooks = {},
		-- 	options = {
		-- 		"-verbose",
		-- 		"-file-line-error",
		-- 		"-synctex=1",
		-- 		"-interaction=nonstopmode",
		-- 	},
		-- }
	end,
}
