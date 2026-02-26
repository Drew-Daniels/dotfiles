local function get_js_formatters()
	local current_bfr_path = vim.api.nvim_buf_get_name(0)
	-- if string.match(current_bfr_path, "blog") ~= nil then
	-- 	return { "eslint_d" }
	-- else
	-- 	return { "eslint_d", "prettierd" }
	-- end
	return { "eslint_d" }
end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	init = function()
		-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#format-command
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
		-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
		-- https://github.com/stevearc/conform.nvim/issues/92#issuecomment-2069915330
		vim.api.nvim_create_user_command("DiffFormat", function()
			local hunks = require("gitsigns").get_hunks()
			local format = require("conform").format
			for i = #hunks, 1, -1 do
				local hunk = hunks[i]
				if hunk ~= nil and hunk.type ~= "delete" then
					local start = hunk.added.start
					local last = start + hunk.added.count
					-- nvim_buf_get_lines uses zero-based indexing -> subtract from last
					local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
					local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
					format({ range = range })
				end
			end
		end, { desc = "Format changed lines" })
	end,
	config = function()
		---@module "conform"
		---@type conform.setupOpts
		local opts = {
			-- log_level = vim.log.levels.TRACE,
			format_after_save = function(bufnr)
				local ignore_filetypes = { "norg" }
				-- Do not autoformat on ignored filetypes
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				-- Do not autoformat when autoformatting is disabled globally on on this buffer
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				-- Do not autoformat when buffer name matches pattern
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("/pom%.xml$/") then
					return
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters_by_ft = {
				bzl = { "buildifier" },
				c = { "clang-format" },
				cmake = { "gersemi" },
				cpp = { "clang-format" },
				-- cpp = { "uncrustify" },
				-- TODO: Re-enable once this is fixed: https://github.com/antham/ghokin/issues/76#issuecomment-3474465409
				-- cucumber = { "ghokin" },
				cucumber = { "reformat-gherkin" },
				d2 = { "d2" },
				-- lua = { "stylua" },
				lua = function()
					local current_bfr_path = vim.api.nvim_buf_get_name(0)
					if string.match(current_bfr_path, "tmpl$") ~= nil then
						return { "trim_whitespace" }
					else
						return { "stylua" }
					end
				end,
				hurl = { "hurlfmt" },
				html = { "htmlbeautifier" },
				http = { "kulala-fmt" },
				ruby = { "standardrb" },
				rust = { "rustfmt" },
				eruby = { "htmlbeautifier" },
				-- TODO: Figure out why .fish.tmpl files are still being interpreted by conform as `fish` files. Likely because of one of my chezmoi neovim plugins setting the filetype to `fish`.
				-- Might make sense to have `conform` have more intelligent checks for filetypes, but may just need to have workarounds when using templates
				-- TODO: Find a more DRY way of deactivating file-specific formatters when editing .tmpl files.
				-- fish = { "fish_indent" },
				fish = function()
					local current_bfr_path = vim.api.nvim_buf_get_name(0)
					if string.match(current_bfr_path, "tmpl$") ~= nil then
						return { "trim_whitespace" }
					else
						return { "fish_indent" }
					end
				end,
				go = { "goimports", "gofmt", stop_after_first = true },
				templ = { "templ" },
				-- json = { "jq" },
				-- TODO: Figure out how to conditionally use `prettierd` in `medplum-` repos and `jq` otherwise
				json = { "prettierd" },
				jsonc = { "jq" },
				json5 = { "fixjson" },
				query = { "format-queries" },
				-- sh = { "shfmt", "shellcheck" },
				sh = function()
					local current_bfr_path = vim.api.nvim_buf_get_name(0)
					if string.match(current_bfr_path, "tmpl$") ~= nil then
						return { "trim_whitespace" }
					else
						return { "shfmt", "shellcheck" }
					end
				end,
				sql = { "sqlfmt" },
				java = { "astyle" },
				javascript = get_js_formatters,
				typescript = get_js_formatters,
				-- javascriptreact = { "prettierd" },
				-- typescriptreact = { "prettierd" },
				-- javascript = { "biome", "biome-check" },
				-- typescript = { "biome", "biome-check" },
				-- javascriptreact = { "biome", "biome-check" },
				-- typescriptreact = { "biome", "biome-check" },
				-- tex = { "tex-fmt" },
				-- toml = { "taplo" },
				toml = function()
					local current_bfr_path = vim.api.nvim_buf_get_name(0)
					if string.match(current_bfr_path, "tmpl$") ~= nil then
						return { "trim_whitespace" }
					else
						return { "taplo" }
					end
				end,
				vue = { "eslint_d" },
				svelte = { "eslint_d", "prettierd" },
				css = { "prettierd" },
				less = { "prettierd" },
				scss = { "prettierd" },
				zig = { "zigfmt" },
				-- zsh = { "shfmt", "shellcheck" },
				zsh = function()
					local current_bfr_path = vim.api.nvim_buf_get_name(0)
					if string.match(current_bfr_path, "tmpl$") ~= nil then
						return { "trim_whitespace" }
					else
						return { "shfmt", "shellcheck" }
					end
				end,
				-- TODO: I think the 'injected' formatter is causing some issues when editing `.md` files within Obsidian vault directories. Should investigate
				markdown = function()
					local obsidian_vaults_path = vim.fn.expand("~") .. "/vaults"
					local current_bfr_path = vim.api.nvim_buf_get_name(0)
					if string.match(current_bfr_path, "^" .. obsidian_vaults_path) ~= nil then
						return { "prettierd" }
					else
						return { "prettierd", "injected" }
					end
				end,
				-- TODO: Create an issue: https://github.com/EbodShojaei/bake/issues
				-- For some reason keep getting upgrade notice even when using the latest version, and no other versions installed
				-- make = { "bake" },
				nix = { "nixfmt" },
				sshconfig = { lsp_fallback = true },
				sudoers = { lsp_fallback = true },
				fail2ban = { lsp_fallback = true },
				crontab = { lsp_fallback = true },
				nginx = { lsp_fallback = true },
				torrc = { lsp_fallback = true },
				-- NOTE: 'nufmt' is still in alpha state: https://github.com/nushell/nufmt/issues/62
				-- nu = { "nufmt" },
				norg = { "typos-lsp" },
				clojure = { "cljfmt" },
				python = { "ruff" },
				terraform = { "terraform_fmt" },
				-- NOTE: Should be handled through tinymist: https://github.com/Myriad-Dreamin/tinymist/blob/main/editors/neovim/README.md#configuration
				-- typst = { "typstyle" },
				yaml = { "yamlfmt" },
				xml = { "xmlstarlet" },
				-- NOTE: If I want to use below formatters on every ft
				-- ["*"] = { "trim_whitespace" },
				-- NOTE: If I only want to use below formatters on buffer fts that do not have a formatter configured
				["_"] = { "trim_whitespace" },
			},
			formatters = {},
		}

		require("conform").setup(opts)
	end,
}
