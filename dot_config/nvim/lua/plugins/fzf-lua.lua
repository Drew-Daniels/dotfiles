return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		{ "max-perf", "ivy", "hide" },
		lsp = {
			async_or_timeout = 10000,
		},
		grep = {
			-- rg_opts = "--column --line-number --no-heading --color=always --smart-case",
			RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
		},
		-- https://github.com/ibhagwan/fzf-lua/wiki#how-do-i-send-all-grep-results-to-quickfix-list
		keymap = {
			fzf = {
				true,
				-- Use <c-q> to select all items and add them to the quickfix list
				["ctrl-q"] = "select-all+accept",
			},
		},
	},
}
