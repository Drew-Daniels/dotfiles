return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		-- NOTE: Can use `max-perf` once this is addressed, otherwise hard to preview files in light mode: https://github.com/ibhagwan/fzf-lua/issues/2430
		-- { "max-perf", "ivy", "hide" },
		{ "ivy", "hide" },
		-- previewers = {
		-- 	bat = {
		-- 		-- NOTE: Can set the theme that should be used for bat file previews, when using fzf-native, but only one theme can be specified
		-- 		-- Alternative to this is NOT using fzf-native
		-- 		-- dark
		-- 		theme = "gruvbox-dark",
		-- 		-- light
		-- 		-- theme = "Catppuccin Latte",
		-- 	},
		-- },
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
