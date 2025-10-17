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
		vim.api.nvim_create_user_command("DiffFormat", function()
			local lines = vim.fn.system("git diff --unified=0"):gmatch("[^\n\r]+")
			local ranges = {}
			for line in lines do
				if line:find("^@@") then
					local line_nums = line:match("%+.- ")
					if line_nums:find(",") then
						local _, _, first, second = line_nums:find("(%d+),(%d+)")
						table.insert(ranges, {
							start = { tonumber(first), 0 },
							["end"] = { tonumber(first) + tonumber(second), 0 },
						})
					else
						local first = tonumber(line_nums:match("%d+"))
						table.insert(ranges, {
							start = { first, 0 },
							["end"] = { first + 1, 0 },
						})
					end
				end
			end
			local format = require("conform").format
			for _, range in pairs(ranges) do
				format({
					range = range,
				})
			end
		end, { desc = "Format changed lines" })
	end,
	config = function()
		---@module "conform"
		---@type conform.setupOpts
		local opts = {
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
