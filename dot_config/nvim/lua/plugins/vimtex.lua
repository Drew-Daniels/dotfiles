return {
	"lervag/vimtex",
	cond = false,
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		-- vim.g.vimtex_view_method = "zathura"
		-- NOTE: Using sioyek instead of zathura because it's a more cross-platform friendly alternative
		vim.g.vimtex_view_method = "sioyek"
		-- silence warning that tree-sitter is being used for syntax highlighting
		vim.g.vimtex_syntax_enabled = 0
		-- NOTE: 'latexmk' is included with texlive by default, and supports automatic re-compilation upon changes
		-- NOTE: vimtex should use this compiler by default
		-- vim.g.vimtex_compiler_method = "latexmk"
	end,
}
