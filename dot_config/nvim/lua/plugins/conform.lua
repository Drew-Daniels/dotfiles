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
				-- FormatDisable! will disable formatting just for this buffer
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
	end,
	config = function()
		---@module "conform"
		---@type conform.setupOpts
		local opts = {
			format_after_save = function(bufnr)
				local ignore_filetypes = { "norg" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
			end,
			formatters_by_ft = {
				bzl = { "buildifier" },
				c = { "clang-format" },
				cmake = { "gersemi" },
				cpp = { "clang-format" },
				-- cpp = { "uncrustify" },
				cucumber = { "ghokin" },
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
