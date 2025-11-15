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
				{ "<leader>c", group = "Comment" },
				{ "<leader>cb", "<cmd>CBccbox<cr>", desc = "Box" },
				{ "<leader>ct", "<cmd>CBllline<cr>", desc = "Titled Line" },
				{ "<leader>cl", "<cmd>CBline<cr>", desc = "Line" },
				{ "<leader>cm", "<cmd>CBllbox14<cr>", desc = "Marked" },
				{ "<leader>cq", "<cmd>CBllbox13<cr>", desc = "Quoted" },
				{ "<leader>cr", "<cmd>CBd<cr>", desc = "Remove box" },
			},
			-- conform.nvim
			-- TODO: Look into consolidating these keybinds with `<leader>p` since they all handle formatting related things
			{ "<leadder>F", group = "Formatters" },
			{ "<leader>Fc", "<cmd>DiffFormat<cr>", desc = "Changed" },
			{ "<leader>Fi", "<cmd>ConformInfo<cr>", desc = "Info" },
			{ "<leader>Fd", "<cmd>FormatDisable<cr>", desc = "Disable" },
			{ "<leader>Fe", "<cmd>FormatEnable<cr>", desc = "Enable" },
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
			{ "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "History - All Files" },
			{ "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "History - Current File" },
			{ "<leader>df", "<cmd>DiffviewFocusFiles<cr>", desc = "Focus Files" },
			{ "<leader>dr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh" },
			{ "<leader>dt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle Files" },
			{ "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Open" },
			{ "<leader>dm", "<cmd>DiffviewOpen main..@<cr>", desc = "Main to Current" },
			{ "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "Quit" },
			{ "<leader>dx", "<cmd>DiffviewFileHistory<cr>", desc = "Selected" },
			-- Debug
			{ "<leader>D", group = "Debug" },
			{ "<leader>Db", "<cmd>DapToggleBreakpoint<cr>", desc = "Breakpoint" },
			{ "<leader>Dc", "<cmd>DapContinue<cr>", desc = "Continue" },
			{ "<leader>DC", "<cmd>lua require('dap').run_to_cursor()<cr>", desc = "Run to Cursor" },
			{ "<leader>Dp", "<cmd>DapPause<cr>", desc = "Pause" },
			{ "<leader>De", "<cmd>DapTerminate<cr>", desc = "End" },
			{ "<leader>Dx", "<cmd>DapClearBreakpoint<cr>", desc = "X Breakpoints" },
			{ "<leader>Dl", "<cmd>DapShowLog<cr>", desc = "Log" },
			{ "<leader>Di", "<cmd>DapStepInto<cr>", desc = "(Step) Into" },
			{ "<leader>Do", "<cmd>DapStepOver<cr>", desc = "(Step) Over" },
			{ "<leader>DO", "<cmd>DapStepOut<cr>", desc = "(Step) Out" },
			{ "<leader>Dn", "<cmd>DapNew<cr>", desc = "New" },
			{ "<leader>Dr", "<cmd>DapToggleRepl<cr>", desc = "REPL" },
			{ "<leader>Ds", "<cmd>lua require('dapui').open()<cr>", desc = "Show UI" },
			{ "<leader>Dh", "<cmd>lua require('dapui').close()<cr>", desc = "Hide UI" },
			{ "<leader>Dt", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
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
			-- TODO: Think through how to not have these mappings conflict with defaults from comment.nvim: https://github.com/numToStr/Comment.nvim?tab=readme-ov-file#extra-mappings
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
			-- nvim-colorizer
			-- TODO: Come up with a better prefix
			{ "<leader>w", group = "Colorizer" },
			{ "<leader>wa", "<cmd>ColorizerAttachToBuffer<cr>", desc = "ColorizerAttachToBuffer" },
			{ "<leader>wd", "<cmd>ColorizerDetachToBuffer<cr>", desc = "ColorizerDetachToBuffer" },
			{ "<leader>wr", "<cmd>ColorizerReloadAllBuffers<cr>", desc = "ColorizerReloadAllBuffers" },
			{ "<leader>wt", "<cmd>ColorizerToggle<cr>", desc = "ColorizerToggle" },
			-- LaTex
			{ "<leader>V", group = "LaTeX" },
			{
				"<leader>Vt",
				function()
					return require("vimtex.fzf-lua").run()
				end,
				desc = "ToC",
			},
			{
				"<leader>Vc",
				-- When using 'latexmk' as compiler backend for vimtex, this will automatically recompile upon changes
				"<cmd>VimtexCompile<cr>",
				desc = "VimtexCompile",
			},
			{ "<leader>Vi", "<cmd>VimtexInfo<cr>", desc = "VimtexInfo" },
			{ "<leader>Vs", "<cmd>VimtexStatus<cr>", desc = "VimtexStatus" },
			{ "<leader>Vx", "<cmd>VimtexStop<cr>", desc = "VimtexStop" },
			{ "<leader>Vl", "<cmd>VimtexLog<cr>", desc = "VimtexLog" },
			{ "<leader>Vr", "<cmd>VimtexReload<cr>", desc = "VimtexReload" },
			{ "<leader>Vv", "<cmd>VimtexView<cr>", desc = "VimtexView" },
			-- Notes
			{ "<leader>n", group = "Notes (Obsidian.nvim)" },
			{ "<leader>nb", "<cmd>Obsidian backlinks<cr>", desc = "backlinks" },
			{ "<leader>nc", "<cmd>Obsidian check<cr>", desc = "check" },
			{ "<leader>nd", "<cmd>Obsidian dailies<cr>", desc = "dailies" },
			{ "<leader>nf", "<cmd>Obsidian follow_link<cr>", desc = "follow_link" },
			{ "<leader>nl", "<cmd>Obsidian links<cr>", desc = "links" },
			{ "<leader>nn", "<cmd>Obsidian new<cr>", desc = "new" },
			{ "<leader>nN", "<cmd>Obsidian new_from_template<cr>", desc = "new_from_template" },
			{ "<leader>no", "<cmd>Obsidian open<cr>", desc = "open" },
			{ "<leader>np", "<cmd>Obsidian paste_img<cr>", desc = "paste_img" },
			{ "<leader>nq", "<cmd>Obsidian quick_search<cr>", desc = "quick_search" },
			{ "<leader>nr", "<cmd>Obsidian rename<cr>", desc = "rename" },
			{ "<leader>ns", "<cmd>Obsidian search<cr>", desc = "search" },
			{ "<leader>nt", "<cmd>Obsidian tags<cr>", desc = "tags" },
			{ "<leader>nT", "<cmd>Obsidian template<cr>", desc = "template" },
			{ "<leader>nto", "<cmd>Obsidian toc<cr>", desc = "toc" },
			{ "<leader>nw", "<cmd>Obsidian workspace<cr>", desc = "workspace" },
			{ "<leader>np", "<cmd>Obsidian yesterday<cr>", desc = "Previous Daily" },
			{ "<leader>nc", "<cmd>Obsidian today<cr>", desc = "Current Daily" },
			{ "<leader>nn", "<cmd>Obsidian tomorrow<cr>", desc = "Next Daily" },
			-- Neogen
			{ "<leader>N", group = "Neogen" },
			{
				"<leader>Nf",
				"<cmd>lua require('neogen').generate({ type = 'func' })<cr>",
				desc = "Generate Function Annotation",
			},
			{
				"<leader>Nc",
				"<cmd>lua require('neogen').generate({ type = 'class' })<cr>",
				desc = "Generate Class Annotation",
			},
			{
				"<leader>Nt",
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
			-- Tinymist
			{ "<leader>t", group = "Tinymist (Typst LSP)" },
			-- { "<leader>tp", "<cmd><cr>", desc = "Buffer" },
			-- { "<leader>tu", "<cmd>FzfLua btags<cr>", desc = "Buffer" },
			-- Tags
			-- { "<leader>t", group = "Tags" },
			-- { "<leader>tb", "<cmd>FzfLua btags<cr>", desc = "Buffer" },
			-- { "<leader>tv", "<cmd>FzfLua tags_grep_visual<cr>", desc = "Visual selection" },
			-- { "<leader>tw", "<cmd>FzfLua tags_grep_cword<cr>", desc = "'word' under cursor" },
			-- { "<leader>tW", "<cmd>FzfLua tags_grep_cWORD<cr>", desc = "'WORD' under cursor" },
			-- { "<leader>tp", "<cmd>FzfLua tags<cr>", desc = "Project" },
			-- { "<leader>ts", "<cmd>FzfLua tags_live_grep<cr>", desc = "Search" },
			-- Tabs
			{ "<leader>T", "<cmd>FzfLua tabs<cr>", desc = "Tabs" },
			-- URLs
			{ "<leader>u", group = "URLs" },
			{ "<leader>ua", "<cmd>UrlView<cr>", desc = "All URLs" },
			{ "<leader>up", "<cmd>UrlView lazy<cr>", desc = "Plugin URLs" },
			-- paste mode
			-- TODO: Come up with a more mnemonically memorable keybind prefix
			-- TODO: Look into if there is a supported way for logging that the paste mode has been changed, such as with vim.notify(':set paste')
			{ "<leader>X", group = "Paste Mode" },
			{
				"<leader>Xp",
				"<cmd>set paste<cr>",
				desc = ":set paste",
			},
			{
				"<leader>Xn",
				"<cmd>set nopaste<cr>",
				desc = ":set nopaste",
			},
			-- Search
			{ "<leader>s", group = "Search" },
			{ "<leader>sb", "<cmd>FzfLua builtin<cr>", desc = "Builtins" },
			{ "<leader>sc", "<cmd>FzfLua colorschemes<cr>", desc = "Colorschemes" },
			{ "<leader>sl", "<cmd>FzfLua grep resume=true<cr>", desc = "Last" },
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
		})
	end,
}
