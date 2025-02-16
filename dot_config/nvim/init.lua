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

-- TODO: Might want to create this command in the plugin/mason.lua file?
-- vim.api.nvim_create_user_command("MasonInstallAll", function()
-- 	vim.cmd("MasonInstall " .. table.concat(mason_options.ensure_installed, " "))
-- end, {})

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

--       ╭───────────────────────────────────────────────────────────────╮
--       │                     NVIM-TS-COMMENTSTRING                     │
--       │https://github.com/JoosepAlviste/nvim-ts-context-commentstring │
--       ╰───────────────────────────────────────────────────────────────╯
---@diagnostic disable-next-line: missing-parameter
require("ts_context_commentstring").setup()

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
