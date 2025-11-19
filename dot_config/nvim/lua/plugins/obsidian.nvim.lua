return {
	"obsidian-nvim/obsidian.nvim",
	-- dev = true,
	-- dir = "~/projects/obsidian-nvim",
	-- cond = false,
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	-- NOTE: Ensure obsidian.nvim commands are only available when viewing notes inside vault(s) below
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/vaults/work/*.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/vaults/work/*.md",
		"BufReadPre " .. vim.fn.expand("~") .. "/vaults/personal/*.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/vaults/personal/*.md",
		"BufReadPre " .. vim.fn.expand("~") .. "/vaults/XXX/*.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/vaults/XXX/*.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		checkbox = {
			-- default
			-- order = { " ", "~", "!", ">", "x" },
			order = { " ", "x" },
			-- Do not create a checkbox when smart_action mapping is triggered on a list item: https://github.com/obsidian-nvim/obsidian.nvim/issues/523#issuecomment-3553774146
			create_new = false,
		},
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
			folder = "templates",
			customizations = {
				ticket = {
					-- TODO: Create an issue in obsidian-nvim about either:
					-- Updating documentation https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#customizations to indicate that both of these properties are required OR
					-- Update the logic so that if only one is provided, the settings are merged with the defaults
					-- Current state, there is a runtime error that occurs when only setting `notes_subdir` but not setting `note_id_func`
					note_id_func = function()
						return require("obsidian.builtin").zettel_id()
					end,
					notes_subdir = "tickets",
				},
			},
			substitutions = {
				-- TODO: Add handling so weekend days are skipped
				-- This way, on Fridays, I can start working on my next Daily for Monday
				yesterday = function()
					return os.date("%Y-%m-%d", os.time() - 86400)
				end,
				tomorrow = function()
					return os.date("%Y-%m-%d", os.time() + 86400)
				end,
			},
		},
		daily_notes = {
			workdays_only = true,
			-- which folders dailies should be placed in
			folder = "dailies",
			-- name of the template to use. Should be a file located in the 'templates' folder
			template = "daily",
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
		-- TODO: This appears to be deprecated now
		-- mappings = {
		-- 	-- TODO: Figure out why this isn't working
		-- 	["<localleader>td"] = {
		-- 		action = function()
		-- 			return require("obsidian").util.toggle_checkbox()
		-- 		end,
		-- 		opts = { buffer = true },
		-- 	},
		-- },
	},
	init = function()
		vim.api.nvim_create_augroup("filetype_markdown", { clear = true })
		vim.api.nvim_create_autocmd(
			{ "BufNewFile", "BufRead" },
			{ pattern = { "*.md" }, command = "set conceallevel=2", group = "filetype_markdown" }
		)
	end,
}
