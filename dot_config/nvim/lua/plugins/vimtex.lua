return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		-- vim.g.vimtex_view_method = "zathura"
		-- NOTE: Using sioyek instead of zathura because it's a more cross-platform friendly alternative
		vim.g.vimtex_view_method = "sioyek"
    -- TODO: Figure out why syntex does not appear to work with sioyek, at least on NixOS
    -- https://gist.github.com/kha-dinh/c8540052854f3c6954b047abd506b799?permalink_comment_id=5004717#gistcomment-5004717
		-- vim.g.vimtex_callback_progpath = vim.fn.exepath("nvim")
		-- silence warning that tree-sitter is being used for syntax highlighting
		vim.g.vimtex_syntax_enabled = 0
		-- NOTE: 'latexmk' is included with texlive by default, and supports automatic re-compilation upon changes
		-- NOTE: vimtex should use this compiler by default
		-- vim.g.vimtex_compiler_method = "latexmk"
	end,
}
