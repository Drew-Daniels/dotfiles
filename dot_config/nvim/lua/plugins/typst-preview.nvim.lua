return {
	"chomosuke/typst-preview.nvim",
	lazy = false, -- or ft = 'typst'
	version = "1.*",
	opts = {
		-- NOTE: Logs to `vim.fn.stdpath 'data' .. '/typst-preview/log.txt'`
		debug = true,
		dependencies_bin = {
			["tinymist"] = vim.fn.exepath("tinymist"),
			["websocat"] = vim.fn.exepath("websocat"),
		},
		-- NOTE: If using `zathura`
		-- open_cmd = "zathura %s",
	}, -- lazy.nvim will implicitly calls `setup {}`
}
