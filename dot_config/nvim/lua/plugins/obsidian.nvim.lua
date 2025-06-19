return {
	"obsidian-nvim/obsidian.nvim",
	dev = true,
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	---@module 'obsidian'
	---@type obsidian.config.ClientOpts
	opts = {
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
		picker = {
			name = "fzf-lua",
			note_mappings = {
				-- Create a new note from your query.
				new = "<C-x>",
				-- Insert a link to the selected note.
				insert_link = "<C-l>",
			},
			tag_mappings = {
				-- Add tag(s) to current note.
				tag_note = "<C-x>",
				-- Insert a tag at the current location.
				insert_tag = "<C-l>",
			},
		},
		completion = {
			nvim_cmp = false,
			blink = true,
			min_chars = 2,
		},
	},
	init = function()
		vim.api.nvim_create_augroup("filetype_markdown", { clear = true })
		vim.api.nvim_create_autocmd(
			{ "BufNewFile", "BufRead" },
			{ pattern = { "*.md" }, command = "set conceallevel=2", group = "filetype_markdown" }
		)
	end,
}
