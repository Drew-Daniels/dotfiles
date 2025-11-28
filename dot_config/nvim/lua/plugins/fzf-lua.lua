return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		-- NOTE: Can use `max-perf` once this is addressed, otherwise hard to preview files in light mode: https://github.com/ibhagwan/fzf-lua/issues/2430
		{ "max-perf", "ivy", "hide" },
		previewers = {
			bat = {
        theme = function ()
          -- return vim.o.bg == "light" and "Catppuccin Latte" or "gruvbox-dark"
          -- TODO: Create a Sublime theme for Zenbones that can be used by `bat`
          -- https://github.com/sharkdp/bat?tab=readme-ov-file#adding-new-themes
          -- return vim.o.bg == "light" and "base16-256" or "gruvbox-dark"
          return vim.o.bg == "light" and "zenbones" or "gruvbox-dark"
        end
			},
		},
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
