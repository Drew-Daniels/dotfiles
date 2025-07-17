return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			-- Miscellaneous
			{ "<leader>p", "<cmd>Format<cr>", desc = "Pretty" },
			{ "<leader>m", "<cmd>Grapple tag<cr>", desc = "Grapple Tag" },
			{ "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple Move" },
			{ "<leader>z", "<cmd>FzfLua spell_suggest<cr>", desc = "Spell Suggest" },
			-- Box
			{ "<leader>c", group = "Comment Box" },
			-- nesting so I don't have to repeat the mode
			{
				mode = { "n", "v" },
				{ "<leader>cb", "<cmd>CBccbox<cr>", desc = "[b]ox" },
				{ "<leader>ct", "<cmd>CBllline<cr>", desc = "[t]itled Line" },
				{ "<leader>cl", "<cmd>CBline<cr>", desc = "[l]ine" },
				{ "<leader>cm", "<cmd>CBllbox14<cr>", desc = "[m]arked" },
				{ "<leader>cq", "<cmd>CBllbox13<cr>", desc = "[q]uoted" },
				{ "<leader>cr", "<cmd>CBd<cr>", desc = "[r]emove box" },
			},
			-- CodeCompanion
			{ "<leadder>c", group = "CodeCompanion" },
			{ "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "Actions" },
			-- Chezmoi
			{ "<leadder>C", group = "Chezmoi" },
			{ "<leader>Ce", "<cmd>ChezmoiFzf<cr>", desc = "Edit" },
			{ "<leader>Cl", "<cmd>ChezmoiList<cr>", desc = "List" },
			-- Codeium
			-- { "<leader>C", group = "Codeium" },
			-- { "<leader>Ce", "<cmd>Codeium Enable<cr>", desc = "Codeium Enable" },
			-- { "<leader>Cd", "<cmd>Codeium Disable<cr>", desc = "Codeium Disable" },
			-- { "<leader>Ct", "<cmd>Codeium Toggle<cr>", desc = "Codeium Toggle" },
			-- { "<leader>Cc", "<cmd>Codeium Chat<cr>", desc = "Codeium Chat" },
			-- Diffview
			{ "<leader>d", group = "Diffview" },
			{ "<leader>da", "<cmd>DiffviewFileHistory<cr>", desc = "All Files" },
			{ "<leader>dc", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File" },
			{ "<leader>df", "<cmd>DiffviewFocusFiles<cr>", desc = "Focus Files" },
			{ "<leader>dr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh" },
			{ "<leader>dt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle Files" },
			{ "<leader>ds", "<cmd>DiffviewOpen<cr>", desc = "Open" },
			{ "<leader>dm", "<cmd>DiffviewOpen main..@<cr>", desc = "Main to Current" },
			{ "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "Quit" },
			{ "<leader>dx", "<cmd>DiffviewFileHistory<cr>", desc = "Selected" },
			-- Debug
			{ "<leader>D", group = "Debug" },
			{ "<leader>Db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
			{ "<leader>Dn", "<cmd>DapNew<cr>" },
			{ "<leader>Do", "<cmd>lua require('dapui').open()<cr>", desc = "Open DAP-UI" },
			{ "<leader>Dc", "<cmd>lua require('dapui').close()<cr>", desc = "Close DAP-UI" },
			{ "<leader>Dt", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle DAP-UI" },
			-- Ex commands
			{ "<leader>e", group = "Ex Commands" },
			{ "<leader>el", "<cmd>FzfLua commands<cr>", desc = "List" },
			{ "<leader>eh", "<cmd>FzfLua command_history<cr>", desc = "History" },
			-- Files
			{ "<leader>f", group = "Files" },
			{ "<leader>fa", "<cmd>FzfLua autocommands<cr>", desc = "Autocommands" },
			{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
			{ "<leader>fc", "<cmd>FzfLua changes<cr>", desc = "Changes" },
			{ "<leader>fc", "<cmd>FzfLua zoxide<cr>", desc = "Directories (Recent)" },
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "File(s)" },
			-- NOTE: Using blines instead of lines since I think I'll only really want to search the current buffer
			-- { "<leader>fl", "<cmd>FzfLua lines<cr>", desc = "File Lines" },
			{ "<leader>fl", "<cmd>FzfLua blines<cr>", desc = "File (Buffer) Lines" },
			-- NOTE: Not as performant as live_grep_native, but might be more dependable.
			-- { "<leader>fs", "<cmd>FzfLua live_grep<cr>", desc = "Live Search" },
			{ "<leader>fs", "<cmd>FzfLua live_grep_native<cr>", desc = "Live Search (Native)" },
			{ "<leader>fp", "<cmd>MarkdownPreview<cr>", desc = "File Preview (Markdown)" },
			{ "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Git-tracked File(s)" },
			{ "<leader>fo", "<cmd>Oil<cr>", desc = "Oil" },
			{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent File(s)" },
			{ "<leader>ft", "<cmd>FzfLua filetypes<cr>", desc = "Filetypes" },
			{ "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
			-- Git
			{ "<leader>g", group = "Git" },
			{ "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "Branches" },
			{ "<leader>gB", "<cmd>FzfLua git_blame<cr>", desc = "Blame" },
			{ "<leader>gc", "<cmd>FzfLua git_bcommits<cr>", desc = "Commits (Buffer)" },
			{ "<leader>gC", "<cmd>FzfLua git_commits<cr>", desc = "Commits (Project)" },
			{ "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Status" },
			{ "<leader>gt", "<cmd>FzfLua git_tags<cr>", desc = "Tags" },
			{ "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "stash" },
			-- Hunks
			{ "<leader>h", group = "Hunks" },
			-- Joining & Unjoining
			{ "<leader>J", group = "Joining" },
			-- TODO: Look into setting up fallbacks to mini-splitjoin when treesj cannot be used
			-- https://github.com/Wansmer/treesj/issues/143
			{ "<leader>Jt", "<cmd>TSJToggle<cr>", desc = "Toggle" },
			{ "<leader>Js", "<cmd>TSJSplit<cr>", desc = "Split" },
			{ "<leader>Jj", "<cmd>TSJJoin<cr>", desc = "Join" },
			-- Keymaps
			{ "<leader>k", group = "Keymaps" },
			{ "<leader>kl", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
			-- LSP
			{ "<leader>l", group = "LSP" },
			{ "<leader>lc", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Code Actions" },
			{ "<leader>ld", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics" },
			{ "<leader>lD", "<cmd>FzfLua lsp_definitions()<cr>", desc = "Definitions" },
			{ "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover" },
			{ "<leader>li", "<cmd>FzfLua lsp_implementations<cr>", desc = "Implementations" },
			{ "<leader>lI", "<cmd>LspInfo<cr>", desc = "Info" },
			{ "<leader>ll", "<cmd>lua vim.diagnostic.loclist()<cr>", desc = "Set Location List" },
			{ "<leader>lo", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Open Float" },
			{ "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature Help" },
			{ "<leader>lS", "<cmd>LspStart<cr>", desc = "Start LSP" },
			{ "<leader>lt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "Type Definitions" },
			{ "<leader>lT", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Type Definition" },
			{ "<leader>lp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Go-To Prev Diagnostic" },
			{ "<leader>ln", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Go-To Next Diagnostic" },
			{ "<leader>lr", "<cmd>FzfLua lsp_references<cr>", desc = "References" },
			{ "<leader>lR", "<cmd>LspRestart<cr>", desc = "Restart" },
			{ "<leader>lQ", "<cmd>LspStop<cr>", desc = "Quit" },
			-- Obsidian
			{ "<leader>o", group = "Obsidian" },
			{ "<leader>op", "<cmd>ObsidianYesterday<cr>", desc = "Obsidian Previous Daily (Yesterday)" },
			{ "<leader>oc", "<cmd>ObsidianToday<cr>", desc = "Obsidian Current Daily (Today)" },
			{ "<leader>on", "<cmd>ObsidianTomorrow<cr>", desc = "Obsidian Next Daily (Tomorrow)" },
			-- Neogen
			{ "<leader>N", group = "Neogen" },
			{
				"<leader>nf",
				"<cmd>lua require('neogen').generate({ type = 'func' })<cr>",
				desc = "Generate Function Annotation",
			},
			{
				"<leader>nc",
				"<cmd>lua require('neogen').generate({ type = 'class' })<cr>",
				desc = "Generate Class Annotation",
			},
			{
				"<leader>nt",
				"<cmd>lua require('neogen').generate({ type = 'type' })<cr>",
				desc = "Generate Type Annotation",
			},
			-- Quickfix
			{ "<leader>q", group = "Quickfix" },
			{ "<leader>ql", "<cmd>FzfLua quickfix<cr>", desc = "List" },
			{ "<leader>qs", "<cmd>FzfLua quickfix_stack<cr>", desc = "Stack" },
			{ "<leader>qh", "<cmd>FzfLua quickfix_history<cr>", desc = "History" },
			-- Requests
			{ "<leader>R", group = "Request" },
			{ "<leader>Rs", "<Plug>RestNvim", desc = "Send" },
			{ "<leader>Rp", "<Plug>RestNvimPreview", desc = "Preview" },
			{ "<leader>Rr", "<Plug>RestNvimLast", desc = "Repeat Last" },
			-- Tags
			{ "<leader>t", group = "Tags" },
			{ "<leader>tb", "<cmd>FzfLua btags<cr>", desc = "Buffer" },
			{ "<leader>tv", "<cmd>FzfLua tags_grep_visual<cr>", desc = "Visual selection" },
			{ "<leader>tw", "<cmd>FzfLua tags_grep_cword<cr>", desc = "'word' under cursor" },
			{ "<leader>tW", "<cmd>FzfLua tags_grep_cWORD<cr>", desc = "'WORD' under cursor" },
			{ "<leader>tp", "<cmd>FzfLua tags<cr>", desc = "Project" },
			{ "<leader>ts", "<cmd>FzfLua tags_live_grep<cr>", desc = "Search" },
			-- Tabs
			{ "<leader>T", "<cmd>FzfLua tabs<cr>", desc = "Tabs" },
			-- URLs
			{ "<leader>u", group = "URLs" },
			{ "<leader>ua", "<cmd>UrlView<cr>", desc = "All URLs" },
			{ "<leader>up", "<cmd>UrlView lazy<cr>", desc = "Plugin URLs" },
			-- Search
			{ "<leader>s", group = "Search" },
			{ "<leader>sb", "<cmd>FzfLua builtin<cr>", desc = "Builtins" },
			{ "<leader>sc", "<cmd>FzfLua colorschemes<cr>", desc = "Colorschemes" },
			{ "<leader>sl", "<cmd>FzfLua grep_last<cr>", desc = "Last" },
			{ "<leader>sL", "<cmd>FzfLua grep_loclist<cr>", desc = "Location List" },
			{ "<leader>sv", "<cmd>FzfLua grep_visual<cr>", desc = "Visual selection" },
			{ "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "'word' under cursor" },
			{ "<leader>sW", "<cmd>FzfLua grep_cWORD<cr>", desc = "'WORD' under cursor" },
			{ "<leader>sm", "<cmd>FzfLua manpages<cr>", desc = "Manpages" },
			{ "<leader>sb", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "Buffer" },
			{ "<leader>sq", "<cmd>FzfLua lgrep_quickfix<cr>", desc = "Quickfix List" },
			{ "<leader>sr", "<cmd>FzfLua registers<cr>", desc = "Registers" },
			{ "<leader>sh", "<cmd>FzfLua helptags<cr>", desc = "Helptags" },
			{ "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
			-- Scratch
			{ "<leader>S", group = "Scratch" },
			{ "<leader>Su", "<cmd>Scratch<cr>", desc = "Scratch Unnamed" },
			{ "<leader>Sn", "<cmd>ScratchWithName<cr>", desc = "Scratch Named" },
			{ "<leader>So", "<cmd>ScratchOpen<cr>", desc = "Scratch Open" },
			{ "<leader>Ss", "<cmd>ScratchOpenFzf<cr>", desc = "Scratch Search" },
			-- Word
			{ "<leader>w", group = "Word" },
			{ "<leader>wd", "<cmd>FzfLua thesaurus lookup<cr>", desc = "Definition" },
			{ "<leader>ws", "<cmd>FzfLua thesaurus query<cr>", desc = "Search" },
		})
	end,
}
