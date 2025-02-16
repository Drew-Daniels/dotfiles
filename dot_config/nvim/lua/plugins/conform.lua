-- local conform_utils = require("conform.util")

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

return {
	"stevearc/conform.nvim",
	opts = {
		-- format_after_save = function(bufnr)
		-- 	local ignore_filetypes = { "norg" }
		-- 	if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
		-- 		return
		-- 	end
		--
		-- 	if in_hm() or in_fs() or in_ss() then
		-- 		-- always use project formatter
		-- 		return { timeout_ms = 500, lsp_format = "never", quiet = true }
		-- 	else
		-- 		return { timeout_ms = 500, lsp_format = "fallback" }
		-- 	end
		-- end,
		-- formatters_by_ft = {
		-- 	c = { "clang-format" },
		-- 	cucumber = { "reformat-gherkin" },
		-- 	lua = { "stylua" },
		-- 	html = { "htmlbeautifier" },
		-- 	-- TODO: Add another variation of project_standardrb that only runs in hm
		-- 	-- See comment below for 'project_standardrb' - for some reason running `bundle exec standardrb --fix ...` also corrects Rubcop offsenses when run via conform.nvim, but doesn't when run manually
		-- 	-- ruby = { "project_rubocop", "fallback_rubocop", "project_standardrb" },
		-- 	ruby = { "project_rubocop", "fallback_rubocop" },
		-- 	-- TODO: Not autofixing standardrb offenses until hm feature branch merged
		-- 	-- ruby = { "project_rubocop", "fallback_rubocop", "standardrb" },
		-- 	-- eruby = { "htmlbeautifier" },
		-- 	fish = { "fish_indent" },
		-- 	json = { "custom_jq" },
		-- 	sh = { "shfmt", "shellcheck" },
		-- 	sql = { "sqlfmt" },
		-- 	javascript = { "project_eslint", "fallback_eslint" },
		-- 	javascriptreact = { "prettier" },
		-- 	typescript = { "eslint" },
		-- 	typescriptreact = { "prettier" },
		-- 	-- vue = { "eslint" },
		-- 	vue = { "project_eslint", "fallback_eslint" },
		-- 	-- TODO: Figure out how to disable prettier from running in folders other than emr-v3
		-- 	-- css = { "prettier" },
		-- 	less = { "prettier" },
		-- 	-- TODO: Figure out how to disable prettier from running in folders other than emr-v3
		-- 	-- scss = { "prettier" },
		-- 	zsh = { "shfmt", "shellcheck" },
		-- 	markdown = { "prettier" },
		-- 	norg = { "typos-lsp" },
		-- 	clojure = { "cljfmt" },
		-- 	python = { "ruff" },
		-- 	yaml = { "yamlfmt" },
		-- },
		-- formatters = {
		-- 	custom_jq = {
		-- 		command = "jq",
		-- 		condition = function()
		-- 			return not in_fs() and not in_ss()
		-- 		end,
		-- 	},
		-- 	project_htmlbeautifier = {
		-- 		command = "htmlbeautifier",
		-- 		condition = run_project_formatter,
		-- 	},
		-- 	fallback_htmlbeautifier = {
		-- 		command = "htmlbeautifier",
		-- 		condition = function()
		-- 			return not in_hm()
		-- 		end,
		-- 	},
		-- 	project_rubocop = {
		-- 		command = "bundle",
		-- 		args = { "exec", "rubocop", "--auto-correct", "--format", "quiet", "$FILENAME" },
		-- 		stdin = false,
		-- 		condition = run_project_formatter,
		-- 	},
		-- 	fallback_rubocop = {
		-- 		command = "bundle",
		-- 		args = { "exec", "rubocop", "--auto-correct", "--format", "quiet", "$FILENAME" },
		-- 		stdin = false,
		-- 		condition = function()
		-- 			return not in_hm()
		-- 		end,
		-- 	},
		-- 	-- TODO: Figure out why this is also running rubocop autofix, but running this same command manually doesn't
		-- 	project_standardrb = {
		-- 		command = "bundle",
		-- 		args = { "exec", "standardrb", "--fix", "-f", "quiet", "$FILENAME" },
		-- 		stdin = false,
		-- 		condition = function()
		-- 			return in_hm()
		-- 		end,
		-- 		exit_codes = { 0, 1 },
		-- 	},
		-- 	project_eslint = {
		-- 		cwd = require("conform.util").root_file(".git"),
		-- 		command = "pnpm",
		-- 		args = { "lint:fix", "$FILENAME" },
		-- 		stdin = false,
		-- 		condition = run_project_formatter,
		-- 		exit_codes = { 0, 1 },
		-- 	},
		-- 	--TODO: Update condition so that it only returns true when there is an eslint config in the root dir
		-- 	fallback_eslint = {
		-- 		command = conform_utils.from_node_modules("eslint"),
		-- 		args = { "--fix", "$FILENAME" },
		-- 		stdin = false,
		-- 		cwd = conform_utils.root_file({
		-- 			"package.json",
		-- 		}),
		-- 		exit_codes = { 0, 1 },
		-- 		condition = function()
		-- 			return not in_hm()
		-- 		end,
		-- 	},
		-- },
	},
	config = function(_, opts)
		require("conform").setup(opts)
	end,
}
