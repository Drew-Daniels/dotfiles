return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	init = function()
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
	end,
	config = function()
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

		---@module "conform"
		---@type conform.setupOpts
		local opts = {
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
				cpp = { "clang-format" },
				-- cpp = { "uncrustify" },
				cucumber = { "reformat-gherkin" },
				d2 = { "d2" },
				lua = { "stylua" },
				hurl = { "hurlfmt" },
				html = { "htmlbeautifier" },
				http = { "kulala-fmt" },
				-- TODO: Add another variation of project_standardrb that only runs in hm
				-- See comment below for 'project_standardrb' - for some reason running `bundle exec standardrb --fix ...` also corrects Rubcop offsenses when run via conform.nvim, but doesn't when run manually
				-- ruby = { "project_rubocop", "fallback_rubocop", "project_standardrb" },
				-- ruby = { "project_rubocop", "fallback_rubocop" },
				-- TODO: Not autofixing standardrb offenses until hm feature branch merged
				ruby = { "project_rubocop", "fallback_rubocop", "standardrb", stop_after_first = true },
				rust = { "rustfmt" },
				eruby = { "htmlbeautifier" },
				fish = { "fish_indent" },
				go = { "gofmt" },
				json = { "custom_jq" },
				sh = { "shfmt", "shellcheck" },
				sql = { "sqlfmt" },
				java = { "astyle" },
				-- javascript = { "project_eslint", "fallback_eslint", "prettierd" },
				-- javascript = { "eslint_d", "prettierd" },
				javascriptreact = { "prettierd" },
				toml = { "taplo" },
				-- typescript = { "eslint_d", "prettierd" },
				typescriptreact = { "prettierd" },
				vue = { "eslint_d" },
				-- vue = { "project_eslint", "fallback_eslint" },
				css = { "prettierd" },
				less = { "prettierd" },
				scss = { "prettierd" },
				zig = { "zigfmt" },
				zsh = { "shfmt", "shellcheck" },
				markdown = { "prettierd", "injected" },
				nix = { "alejandra" },
				norg = { "typos-lsp" },
				clojure = { "cljfmt" },
				python = { "ruff" },
				-- need to figure out why this formatter is borking config/database.yml files
				-- yaml = { "yamlfmt" },
				-- NOTE: Disabling xml formatting for now
				-- xml = { "xmlstarlet" },
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
		}

		require("conform").setup(opts)
	end,
}
