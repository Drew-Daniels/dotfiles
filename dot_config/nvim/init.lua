require("config.lazy")

-- Requires `brew install cormacrelf/tap/dark-notify`
--          ╭─────────────────────────────────────────────────────────╮
--          │                       DARK-NOTIFY                       │
--          │        https://github.com/cormacrelf/dark-notify        │
--          ╰─────────────────────────────────────────────────────────╯

-- TODO: Figure out to set colorscheme based on OS setting in a cross-platform way (Linux and MacOS)
vim.cmd("colorscheme gruvbox")

require("dark_notify").run({
	schemes = {
		-- light = "zenbones",
		-- dark = "zenbones",
		light = "zenbones",
		dark = "gruvbox",
	},
})

local conform_utils = require("conform.util")

---@param rel_project_path string
local function in_project(rel_project_path)
	-- TODO: Use env var here instead of hardcoding projects path
	local joined = "$PROJECTS_DIR/" .. rel_project_path
	local project_dir = vim.fn.expand(joined)
	local root_dir = vim.fs.root(0, ".git")

	return root_dir == project_dir
end

local function in_hm()
	return in_project("sites/healthmatters")
end

local function in_fs()
	return in_project("friendly-snippets")
end

local function in_ss()
	return in_project("schemastore")
end

-- checks if the current buffer/file is in one of the directories provided
local function buff_in_dir(bufr_path, dirs)
	local result = false

	for _, dir in ipairs(dirs) do
		if string.find(bufr_path, dir, 1, true) then
			result = true
		end
	end

	return result
end

local function run_project_formatter()
	--TODO: Provide relative path from project_dir to ignore_dir since multiple subfolders might have the same name
	local enabled_dirs = { "emr-v3" }

	return in_hm() and buff_in_dir(vim.fn.expand("%:p:h"), enabled_dirs)
end

require("conform").setup({
		format_after_save = function(bufnr)
			local ignore_filetypes = { "norg" }
			if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
				return
			end

			if in_hm() or in_fs() or in_ss() then
				-- always use project formatter
				return { timeout_ms = 500, lsp_format = "never", quiet = true }
			else
				return { timeout_ms = 500, lsp_format = "fallback" }
			end
		end,
		formatters_by_ft = {
			c = { "clang-format" },
			cucumber = { "reformat-gherkin" },
			lua = { "stylua" },
			html = { "htmlbeautifier" },
			-- TODO: Add another variation of project_standardrb that only runs in hm
			-- See comment below for 'project_standardrb' - for some reason running `bundle exec standardrb --fix ...` also corrects Rubcop offsenses when run via conform.nvim, but doesn't when run manually
			-- ruby = { "project_rubocop", "fallback_rubocop", "project_standardrb" },
			ruby = { "project_rubocop", "fallback_rubocop" },
			-- TODO: Not autofixing standardrb offenses until hm feature branch merged
			-- ruby = { "project_rubocop", "fallback_rubocop", "standardrb" },
			-- eruby = { "htmlbeautifier" },
			fish = { "fish_indent" },
			json = { "custom_jq" },
			sh = { "shfmt", "shellcheck" },
			sql = { "sqlfmt" },
			javascript = { "project_eslint", "fallback_eslint" },
			javascriptreact = { "prettier" },
			typescript = { "eslint" },
			typescriptreact = { "prettier" },
			-- vue = { "eslint" },
			vue = { "project_eslint", "fallback_eslint" },
			-- TODO: Figure out how to disable prettier from running in folders other than emr-v3
			-- css = { "prettier" },
			less = { "prettier" },
			-- TODO: Figure out how to disable prettier from running in folders other than emr-v3
			-- scss = { "prettier" },
			zsh = { "shfmt", "shellcheck" },
			markdown = { "prettier" },
			norg = { "typos-lsp" },
			clojure = { "cljfmt" },
			python = { "ruff" },
			yaml = { "yamlfmt" },
		},
		formatters = {
			custom_jq = {
				command = "jq",
				condition = function()
					return not in_fs() and not in_ss()
				end,
			},
			project_htmlbeautifier = {
				command = "htmlbeautifier",
				condition = run_project_formatter,
			},
			fallback_htmlbeautifier = {
				command = "htmlbeautifier",
				condition = function()
					return not in_hm()
				end,
			},
			project_rubocop = {
				command = "bundle",
				args = { "exec", "rubocop", "--auto-correct", "--format", "quiet", "$FILENAME" },
				stdin = false,
				condition = run_project_formatter,
			},
			fallback_rubocop = {
				command = "bundle",
				args = { "exec", "rubocop", "--auto-correct", "--format", "quiet", "$FILENAME" },
				stdin = false,
				condition = function()
					return not in_hm()
				end,
			},
			-- TODO: Figure out why this is also running rubocop autofix, but running this same command manually doesn't
			project_standardrb = {
				command = "bundle",
				args = { "exec", "standardrb", "--fix", "-f", "quiet", "$FILENAME" },
				stdin = false,
				condition = function()
					return in_hm()
				end,
				exit_codes = { 0, 1 },
			},
			project_eslint = {
				cwd = require("conform.util").root_file(".git"),
				command = "pnpm",
				args = { "lint:fix", "$FILENAME" },
				stdin = false,
				condition = run_project_formatter,
				exit_codes = { 0, 1 },
			},
			--TODO: Update condition so that it only returns true when there is an eslint config in the root dir
			fallback_eslint = {
				command = conform_utils.from_node_modules("eslint"),
				args = { "--fix", "$FILENAME" },
				stdin = false,
				cwd = conform_utils.root_file({
					"package.json",
				}),
				exit_codes = { 0, 1 },
				condition = function()
					return not in_hm()
				end,
			},
		},
})

-- TODO: Might want to create this command in the plugin/mason.lua file?
-- vim.api.nvim_create_user_command("MasonInstallAll", function()
-- 	vim.cmd("MasonInstall " .. table.concat(mason_options.ensure_installed, " "))
-- end, {})

--          ╭─────────────────────────────────────────────────────────╮
--          │                     NVIM-TREESITTER                     │
--          │   https://github.com/nvim-treesitter/nvim-treesitter    │
--          ╰─────────────────────────────────────────────────────────╯
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"lua",
		"luadoc",
		"vim",
		"vimdoc",
		"query",
		"bash",
		"css",
		"clojure",
		"dockerfile",
		"embedded_template",
		"fish",
		"html",
		"http",
		"javascript",
		"jq",
		"json",
		"jsonc",
		"markdown",
		"markdown_inline",
		"ruby",
		"scheme",
		"scss",
		"sql",
		"terraform",
		"toml",
		"tsx",
		"typescript",
		"yaml",
		"prisma",
		"vue",
		"nix",
		"ssh_config",
		"editorconfig",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"graphql",
		"hurl",
		"nginx",
		"passwd",
		"svelte",
		"swift",
		"tmux",
	},
	-- required by 'nvim-ts-autotag'
	autotag = {
		enable = true,
	},
	-- required by 'nvim-treesitter-endwise'
	endwise = {
		enable = true,
	},
	--       ╭───────────────────────────────────────────────────────────────╮
	--       │                  NVIM-TREESITTER-TEXTOBJECTS                  │
	--       │https://github.com/nvim-treesitter/nvim-treesitter-textobjects │
	--       ╰───────────────────────────────────────────────────────────────╯
	textobjects = {
		lsp_interop = {
			enable = true,
			border = "none",
			floating_preview_opts = {},
			peek_definition_code = {
				["<leader>vf"] = "@function.outer",
				["<leader>vc"] = "@class.outer",
			},
		},
		move = {
			--TODO: Figure out why go-tos for conditionals don't work in .rb files?
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]f"] = { query = "@function.outer", desc = "Next function (start)" },
				["]c"] = { query = "@class.outer", desc = "Next class (start)" },
				["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope (start)" },
				["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold (start)" },
				["]d"] = { query = "@conditional.outer", desc = "Next Conditional (start)" },
			},
			goto_next_end = {
				["]F"] = { query = "@function.outer", desc = "Next function (end)" },
				["]C"] = { query = "@class.outer", desc = "Next class (end)" },
				["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope (end)" },
				["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold (end)" },
				["]D"] = { query = "@conditional.outer", desc = "Next Conditional (end)" },
			},
			goto_previous_start = {
				["[f"] = { query = "@function.outer", desc = "Previous function (start)" },
				["[c"] = { query = "@class.outer", desc = "Previous class (start)" },
				["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope (start)" },
				["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold (start)" },
				["[d"] = { query = "@conditional.outer", desc = "Previous Conditional (start)" },
			},
			goto_previous_end = {
				["[F"] = { query = "@function.outer", desc = "Previous function (end)" },
				["[C"] = { query = "@class.outer", desc = "Previous class (end)" },
				["[S"] = { query = "@scope", query_group = "locals", desc = "Previous scope (end)" },
				["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold (end)" },
				["[D"] = { query = "@conditional.outer", desc = "Previous Conditional (end)" },
			},
		},
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["of"] = { query = "@function.outer", desc = "Select outer function" },
				["if"] = { query = "@function.inner", desc = "Select inner function" },
				["oc"] = { query = "@class.outer", desc = "Select outer class" },
				["ic"] = { query = "@class.inner", desc = "Select inner class" },
				["os"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
				["is"] = { query = "@scope.inner", query_group = "locals", desc = "Select inner language scope" },
				["ol"] = { query = "@loop.outer", desc = "Select outer loop" },
				["il"] = { query = "@loop.inner", desc = "Select inner loop" },
				["ob"] = { query = "@block.outer", desc = "Select outer block" },
				--TODO: Figure out how to select blocks without the curly braces
				["ib"] = { query = "@block.inner", desc = "Select inner block", kind = "exclusive" },
				["od"] = { query = "@conditional.outer", desc = "Select outer conditional" },
				["id"] = { query = "@conditional.inner", desc = "Select inner conditional" },
				["op"] = { query = "@parameter.outer", desc = "Select outer parameter" },
				["ip"] = { query = "@parameter.inner", desc = "Select inner parameter" },
				["oP"] = { query = "@parameter.outer", mode = "a", desc = "Select outer parameter (inclusive)" },
				["iP"] = { query = "@parameter.inner", mode = "a", desc = "Select inner parameter (inclusive)" },
				["o,"] = { query = "@parameter.outer", mode = "i", desc = "Select outer parameter (exclusive)" },
				["i,"] = { query = "@parameter.inner", mode = "i", desc = "Select inner parameter (exclusive)" },
				["o;"] = {
					query = "@parameter.outer",
					mode = "a",
					kind = "inclusive",
					desc = "Select outer parameter (inclusive)",
				},
				["i;"] = {
					query = "@parameter.inner",
					mode = "a",
					kind = "inclusive",
					desc = "Select inner parameter (inclusive)",
				},
				["o:"] = {
					query = "@parameter.outer",
					mode = "i",
					kind = "exclusive",
					desc = "Select outer parameter (exclusive)",
				},
				["i:"] = {
					query = "@parameter.inner",
					mode = "i",
					kind = "exclusive",
					desc = "Select inner parameter (exclusive)",
				},
				["o/"] = { query = "@comment.outer", desc = "Select outer comment" },
				["i/"] = { query = "@comment.inner", desc = "Select inner comment" },
				["o#"] = {
					query = "@comment.outer",
					mode = "i",
					kind = "inclusive",
					desc = "Select outer comment (inclusive)",
				},
				["i#"] = {
					query = "@comment.inner",
					mode = "i",
					kind = "inclusive",
					desc = "Select inner comment (inclusive)",
				},
			},
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "V", -- blockwise
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
		},
	},
	-- my config
	highlight = {
		enable = true,
		-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1352#issuecomment-1449638327
		disable = function()
			if string.find(vim.bo.filetype, "chezmoitmpl") or vim.bo.filetype == "embedded_template" then
				return true
			end
		end,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			--TODO: how to inform whichkey that <leader>s should be used for this?
			init_selection = "<leader>si", -- select start
			node_incremental = "<leader>sn", -- select node (incremental)
			scope_incremental = "<leader>ss", -- select scope
			node_decremental = "<leader>sd", -- select node (decremental)
		},
	},
	indent = {
		enable = true,
	},
})

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
-- TODO: Need to find a better key for repeat_last_move_previous than , since , is my localleader
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move next" })
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Repeat last move previous" })

vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

-- This repeats the last query with always previous direction and to the start of the range.
vim.keymap.set({ "n", "x", "o" }, "<home>", function()
	ts_repeat_move.repeat_last_move({ forward = false, start = true, desc = "Repeat last move" })
end)

-- This repeats the last query with always next direction and to the end of the range.
vim.keymap.set({ "n", "x", "o" }, "<end>", function()
	ts_repeat_move.repeat_last_move({ forward = true, start = false, desc = "Repeat last move" })
end)

-- custom file associations
require("vim.treesitter.language").register("http", "hurl")

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { unpack(opts), desc = "declaration" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { unpack(opts), desc = "definition" })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(opts), desc = "hover" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { unpack(opts), desc = "implementation" })
		vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { unpack(opts), desc = "signature help" })
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { unpack(opts), desc = "type definition" })
		-- vim.keymap.set({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, { unpack(opts), desc = "Code Actions" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { unpack(opts), desc = "references" })
		vim.keymap.set("n", "gR", vim.lsp.buf.rename, { unpack(opts), desc = "rename" })
		-- conform.nvim should handle formatting
		-- vim.keymap.set("n", "<space>f", function()
		-- 	vim.lsp.buf.format({ async = true })
		-- end, { unpack(opts), desc = "format" })
	end,
	desc = "Initialize LSP on LspAttach event",
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                     NVIM-LSPCONFIG                      │
--          │        https://github.com/neovim/nvim-lspconfig         │
--          ╰─────────────────────────────────────────────────────────╯
local lspconfig = require("lspconfig")

local servers = {
	"emmet_language_server",
	"jsonls",
	"html",
	"clangd",
	"cssmodules_ls",
	"docker_compose_language_service",
	"dockerls",
	"emmet_language_server",
	"yamlls",
	"marksman",
	"cucumber_language_server",
	"tailwindcss",
	"terraformls",
	"sqlls",
	"vimls",
	"prismals",
	"volar",
	"nil_ls",
	"clojure_lsp",
	-- turning off for now: https://github.com/nrwl/nx-console/issues/2019
	-- "nxls",
	"ruff",
	"basedpyright",
	"tflint",
}
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({})
end

lspconfig.bashls.setup({
	filetypes = { "bash", "sh", "zsh" },
})

-- lspconfig.vuels.setup({
-- 	cmd = { "vue-language-server", "--stdio" },
-- })

lspconfig.solargraph.setup({
	filetypes = { "ruby", "eruby" },
})

-- TODO: Figure out at what version of standardrb the --lsp flag was added, so I can start using bundler installed version
lspconfig.standardrb.setup({
	-- cmd = { "bundle", "exec", "standardrb", "--lsp" },
})

lspconfig.basedpyright.setup({
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "off",
			},
		},
	},
})

--TODO: Deactive eslint lsp when in an "ignored" directory so things are less noisy
-- https://github.com/neovim/nvim-lspconfig/issues/2508
local root_dir = vim.fs.root(0, ".git")
local use_flat_config = false
if root_dir ~= nil and vim.fn.filereadable(root_dir .. "/eslint.config.js") == 1 then
	use_flat_config = true
end

lspconfig.eslint.setup({
	settings = {
		workingDirectories = { mode = "auto" },
		experimental = {
			useFlatConfig = use_flat_config,
		},
	},
})

lspconfig.cssls.setup({
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		scss = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		less = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
})

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lspconfig.typos_lsp.setup({
	filetypes = { "markdown", "norg" },
	init_options = {
		config = "~/projects/dotfiles/typos/typos.toml",
	},
})

lspconfig.denols.setup({
	root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
	init_options = {
		lint = true,
		suggest = {
			imports = {
				hosts = {
					["https://deno.land"] = true,
				},
			},
		},
	},
})

-- RECOMMENDED 'nvim-lspconfig' SETUP

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

--       ╭───────────────────────────────────────────────────────────────╮
--       │                     NVIM-TS-COMMENTSTRING                     │
--       │https://github.com/JoosepAlviste/nvim-ts-context-commentstring │
--       ╰───────────────────────────────────────────────────────────────╯
---@diagnostic disable-next-line: missing-parameter
require("ts_context_commentstring").setup()

--          ╭─────────────────────────────────────────────────────────╮
--          │                     WHICH-KEY.NVIM                      │
--          │         https://github.com/folke/which-key.nvim         │
--          ╰─────────────────────────────────────────────────────────╯
local wk = require("which-key")

-- TODO: Figure out how to filter FzfLua to just app/ folder and not include search results in spec/
-- TODO: Figure out how to localize search results with <leader>fs to just files that are in the current directory or below
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
	-- Ex commands
	{ "<leader>e", group = "Ex Commands" },
	{ "<leader>el", "<cmd>FzfLua commands<cr>", desc = "List" },
	{ "<leader>eh", "<cmd>FzfLua command_history<cr>", desc = "History" },
	-- Files
	{ "<leader>f", group = "Files" },
	{ "<leader>fa", "<cmd>FzfLua autocommands<cr>", desc = "Autocommands" },
	{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
	{ "<leader>fc", "<cmd>FzfLua changes<cr>", desc = "Changes" },
	{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "File(s)" },
	{ "<leader>fs", "<cmd>FzfLua live_grep<cr>", desc = "Live Search" },
	-- { "<leader>fs", "<cmd>FzfLua live_grep_native<cr>", desc = "Live Search" },
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
	{ "<leader>h", group = "Hunks", desc = "Hunks" },
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
	-- Neogen
	{ "<leader>N", group = "Neogen" },
	{
		"<leader>nf",
		"<cmd>lua require('neogen').generate({ type = 'func' })<cr>",
		desc = "Generate Function Annotation",
	},
	{ "<leader>nc", "<cmd>lua require('neogen').generate({ type = 'class' })<cr>", desc = "Generate Class Annotation" },
	{ "<leader>nt", "<cmd>lua require('neogen').generate({ type = 'type' })<cr>", desc = "Generate Type Annotation" },
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

vim.api.nvim_create_user_command("SU", function(opts)
	local date = os.date("%Y-%m-%d")
	if opts.fargs[1] == "yd" then
		date = os.date("%Y-%m-%d", os.time() - 86400)
	elseif opts.fargs[1] == "td" then
		date = os.date("%Y-%m-%d")
	elseif opts.fargs[1] == "tm" and os.date("%w") == "5" then
		-- If td is Friday, then next business day is Monday
		date = os.date("%Y-%m-%d", os.time() + 86400 * 3)
	elseif opts.fargs[1] == "tm" then
		date = os.date("%Y-%m-%d", os.time() + 86400)
	else
		print("Invalid date")
		return
	end
	vim.cmd("e ~/projects/work_notes/su/2024/" .. date .. ".norg")
end, { range = false, nargs = 1 })

vim.api.nvim_create_user_command("Project", function(opts)
	local name = opts.fargs[1]
	if type(name) ~= "string" then
		print("Invalid name")
		return
	end
	vim.cmd("e ~/projects/work_notes/projects/" .. name .. ".norg")
end, { nargs = "*" })

-- TODO: De-hardcode paths here
vim.cmd([[
  augroup neorg_cmds
    autocmd BufNewFile ~/projects/work_notes/su/**/*.norg 0read ~/projects/dotfiles/dotfiles/nvim/norg/templates/standup_template.norg
    autocmd FileType norg setlocal conceallevel=3
    " Figure out how to stop folds from getting created on buffers created after first entering into a .norg buffer
    autocmd BufWritePost ~/projects/work_notes/su/**/*.norg silent !git -C ~/projects/work_notes/su/ add . && git -C ~/projects/work_notes/su/ commit -m "Update work notes" && git -C ~/projects/work_notes/su/ push
    autocmd BufWritePost ~/projects/work_notes/projects/*.norg silent !git -C ~/projects/work_notes/projects/ add . && git -C ~/projects/work_notes/projects/ commit -m "Update work notes" && git -C ~/projects/work_notes/projects/ push
  augroup END
]])

--          ╭─────────────────────────────────────────────────────────╮
--          │                       COPILOT.VIM                       │
--          │          https://github.com/github/copilot.vim          │
--          ╰─────────────────────────────────────────────────────────╯
vim.cmd([[
  let g:copilot_filetypes = { 'norg': v:false }
]])

--          ╭─────────────────────────────────────────────────────────╮
--          │                       VIM-RHUBARB                       │
--          │          https://github.com/tpope/vim-rhubarb           │
--          ╰─────────────────────────────────────────────────────────╯
-- TODO: Figure out if this function can be created in the vim-rhubarb plugin file
vim.api.nvim_create_user_command("Browse", function(opts)
	vim.fn.system({ "open", opts.fargs[1] })
end, { nargs = 1 })

--          ╭─────────────────────────────────────────────────────────╮
--          │                         Codeium                         │
--          │       https://github.com/Exafunction/codeium.vim        │
--          ╰─────────────────────────────────────────────────────────╯
-- vim.g.codeium_disable_bindings = 1
-- vim.g.codeium_no_map_tab = 1
-- -- defaults: https://github.com/Exafunction/codeium.vim?tab=readme-ov-file#%EF%B8%8F-keybindings
-- -- set the Meta key in iTerm2 > Preferences > Profiles > Keys > Left Option Key to Esc+
-- vim.keymap.set("i", "<C-g>", function()
--   return vim.fn["codeium#Accept"]()
-- end, { expr = true, silent = true, desc = "Codeium Accept" })
--
-- vim.keymap.set("i", "<C-x>", function()
--   return vim.fn["codeium#Clear"]()
-- end, { expr = true, silent = true, desc = "Codeium Clear" })
--
-- vim.cmd([[
--   let g:codeium_filetypes = {
--     \ "norg": v:false,
--     \ "text": v:false,
--     \ }
--   let g:codeium_os = "Darwin"
--   let g:codeium_arch = "arm"
-- ]])
--

-- ── GENERAL ─────────────────────────────────────────────────────────

-- Deactivate LSP logging except only when necessary, since this file can become huge overtime when permanently left on
-- vim.lsp.set_log_level("debug")
vim.lsp.set_log_level("off")

vim.keymap.set("n", "n", "nzz", { silent = true, desc = "Search Next" })
vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Search Prev" })
vim.keymap.set("i", "<C-b>", "<CR><ESC>kA<CR>", { silent = true, desc = "Insert blank line" })

local function yank_buffer_file_path()
	local full_path = vim.api.nvim_buf_get_name(0)
	local relative_path = vim.fn.fnamemodify(full_path, ":.")
	vim.fn.setreg("+", relative_path)
	vim.notify("Copied Buffer File Path to Clipboard: " .. vim.fn.getreg("+"), vim.log.levels.INFO)
end

-- TODO: Dedupe shared steps
local function yank_buffer_file_name()
	local full_path = vim.api.nvim_buf_get_name(0)
	local file_name = vim.fn.fnamemodify(full_path, ":t")
	vim.fn.setreg("+", file_name)
	vim.notify("Copied Buffer File Name to Clipboard: " .. vim.fn.getreg("+"), vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>Yp", yank_buffer_file_path, {
	silent = true,
	desc = "Yank Buffer File Path to Clipboard",
})

vim.keymap.set("n", "<leader>Yn", yank_buffer_file_name, {
	silent = true,
	desc = "Yank Buffer File Name to Clipboard",
})

vim.keymap.set("i", "<C-o>", "<CR><ESC>I")
-- do not open folds when searching for text
vim.cmd([[set foldopen-=search]])
-- do not open folds when moving cursor
vim.diagnostic.config({ virtual_text = { source = true } })

vim.filetype.add({
	filename = {
		["Brewfile"] = "brewfile",
	},
})
