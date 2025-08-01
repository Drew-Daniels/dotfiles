return {
	"obsidian-nvim/obsidian.nvim",
	-- dev = true,
	-- NOTE: Disabling this plugin for now becuase their is an issue wh
	cond = false,
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- NOTE: Create a bug report for obsidian.nvim being loaded even when outside of a vault? Also when working on non-markdown files.
	-- event = {
	-- 	-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	-- 	-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	-- 	-- refer to `:h file-pattern` for more examples
	-- 	"BufReadPre "
	-- 		.. vim.fn.expand("~")
	-- 		.. "/vaults/personal/*.md",
	-- 	"BufReadPre " .. vim.fn.expand("~") .. "/vaults/work/*.md",
	-- 	"BufReadPre " .. vim.fn.expand("~") .. "/vaults/xxx/*.md",
	-- 	"BufNewFile " .. vim.fn.expand("~") .. "/vaults/personal/*.md",
	-- 	"BufNewFile " .. vim.fn.expand("~") .. "/vaults/work/*.md",
	-- 	"BufNewFile " .. vim.fn.expand("~") .. "/vaults/xxx/*.md",
	-- },
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		legacy_commands = false,
		workspaces = {
			{
				name = "personal",
				path = "~/vaults/personal",
			},
			{
				name = "xxx",
				path = "~/vaults/xxx",
			},
			{
				name = "work",
				path = "~/vaults/work",
			},
		},
		templates = {
			folder = "~/vaults/work/templates",
		},
		daily_notes = {
			workdays_only = true,
			folder = "dailies",
			template = "daily",
		},
		picker = {
			name = "fzf-lua",
			note_mappings = {
				new = "<C-x>",
				insert_link = "<C-l>",
			},
			tag_mappings = {
				tag_note = "<C-x>",
				insert_tag = "<C-l>",
			},
		},
		completion = {
			nvim_cmp = false,
			blink = true,
			min_chars = 2,
		},
	},
}
