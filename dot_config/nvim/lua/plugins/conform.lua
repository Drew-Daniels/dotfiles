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
				lua = { "stylua" },
				hurl = { "hurlfmt" },
				html = { "htmlbeautifier" },
				http = { "kulala-fmt" },
				ruby = { "standardrb" },
				rust = { "rustfmt" },
				eruby = { "htmlbeautifier" },
				fish = { "fish_indent" },
				go = { "gci", "golines", "gofmt" },
				templ = { "templ" },
				json = { "jq" },
				query = { "format-queries" },
				sh = { "shfmt", "shellcheck" },
				sql = { "sqlfmt" },
				java = { "astyle" },
				-- javascript = { "eslint_d", "prettierd" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d", "prettierd" },
				-- typescript = { "eslint_d" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				-- javascript = { "biome", "biome-check" },
				-- typescript = { "biome", "biome-check" },
				-- javascriptreact = { "biome", "biome-check" },
				-- typescriptreact = { "biome", "biome-check" },
				tex = { "tex-fmt" },
				toml = { "taplo" },
				vue = { "eslint_d" },
				css = { "prettierd" },
				less = { "prettierd" },
				scss = { "prettierd" },
				zig = { "zigfmt" },
				zsh = { "shfmt", "shellcheck" },
				markdown = { "prettierd", "injected" },
				makefile = { "bake" },
				nix = { "nixfmt" },
				nginx = { "nginxfmt" },
				norg = { "typos-lsp" },
				clojure = { "cljfmt" },
				python = { "ruff" },
				terraform = { "terraform_fmt" },
				-- NOTE: Should be handled through tinymist: https://github.com/Myriad-Dreamin/tinymist/blob/main/editors/neovim/README.md#configuration
				-- typst = { "typstyle" },
				yaml = { "yamlfmt" },
				xml = { "xmlstarlet" },
			},
			formatters = {},
		}

		require("conform").setup(opts)
	end,
}
