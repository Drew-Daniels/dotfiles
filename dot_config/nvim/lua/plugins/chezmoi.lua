return {
	"alker0/chezmoi.vim",
	lazy = false,
	init = function()
		-- This option is required.
		vim.g["chezmoi#use_tmp_buffer"] = true
		-- add other options here if needed.
		-- MY OPTIONS START --
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = "*.sh.tmpl",
			command = "set filetype=bash",
			group = "filetypedetect",
		})
		-- MY OPTIONS END --
	end,
}
