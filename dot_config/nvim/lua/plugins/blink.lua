return {
	"saghen/blink.cmp",
	lazy = false,
	dependencies = {
		"rafamadriz/friendly-snippets",
		-- "Exafunction/codeium.vim",
	},
	-- dev = true,
	version = "v1.*",
	-- version = "v0.*",
	-- NOTE: Need to run this build manually
	-- build = "cargo build --release",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			["<C-u>"] = { "scroll_documentation_up" },
			["<C-d>"] = { "scroll_documentation_down" },
			["<C-n>"] = { "select_next" },
			["<C-p>"] = { "select_prev" },
			["<C-e>"] = { "accept" },
			["<C-space>"] = { "show" },
			["<C-q>"] = { "hide" },
			-- TODO: Conflicting with diacritic keybinding
			-- ["<C-k>"] = { "show_documentation" },
			["<C-j>"] = { "snippet_forward" },
			["<C-h>"] = { "snippet_backward" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		completion = {
			documentation = {
				auto_show = true,
			},
		},
		sources = {
			per_filetype = {
				codecompanion = { "codecompanion" },
			},
			-- default = { "lsp", "path", "snippets", "buffer", "lazydev", "codeium" },
			default = { "lsp", "path", "snippets", "buffer", "lazydev" },
			providers = {
				-- codeium = { name = "Codeium", module = "codeium.blink", async = true },
				lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
				snippets = {
					name = "Snippets",
					module = "blink.cmp.sources.snippets",
					score_offset = -3,
					opts = {
						friendly_snippets = true,
						search_paths = { vim.fn.stdpath("config") .. "/snippets" },
						global_snippets = { "all" },
						extended_filetypes = {
							eruby = { "ruby", "javascript" },
							typescript = { "javascript" },
							vue = { "javascript", "html", "css" },
						},
						ignored_filetypes = {},
					},
				},
			},
		},
	},
}
