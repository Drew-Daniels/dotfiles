return {
	"neovim/nvim-lspconfig",
	config = function(_, _)
		local lspconfig = require("lspconfig")
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		-- TODO: Modularize configuration so that 'capabilities = capabilities' setting is used for every lsp
		--TODO: Deactivate eslint lsp when in an "ignored" directory so things are less noisy
		-- https://github.com/neovim/nvim-lspconfig/issues/2508
		local root_dir = vim.fs.root(0, ".git")
		local use_flat_config = false
		if root_dir ~= nil and vim.fn.filereadable(root_dir .. "/eslint.config.js") == 1 then
			use_flat_config = true
		end

		vim.lsp.config("bashls", {
			capabilities = capabilities,
			filetypes = { "bash", "sh", "zsh" },
		})

		vim.lsp.config("basedpyright", {
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "off",
					},
				},
			},
		})

		vim.lsp.config("clangd", {
			capabilities = capabilities,
		})

		vim.lsp.config("clojure_lsp", {
			capabilities = capabilities,
		})

		vim.lsp.config("cssls", {
			capabilities = capabilities,
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

		vim.lsp.config("cssmodules_ls", {
			capabilities = capabilities,
		})

		vim.lsp.config("cucumber_language_server", {
			capabilities = capabilities,
		})

		vim.lsp.config("denols", {
			capabilities = capabilities,
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

		vim.lsp.config("docker_compose_language_service", {
			capabilities = capabilities,
		})

		vim.lsp.config("dockerls", {
			capabilities = capabilities,
		})

		vim.lsp.config("emmet_language_server", {
			capabilities = capabilities,
		})

		vim.lsp.config("eslint", {
			capabilities = capabilities,
			settings = {
				workingDirectories = { mode = "auto" },
				experimental = {
					useFlatConfig = use_flat_config,
				},
			},
		})

		vim.lsp.config("html", {
			capabilities = capabilities,
		})

		vim.lsp.config("jsonls", {
			capabilities = capabilities,
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		vim.lsp.config("marksman", {
			capabilities = capabilities,
		})

		vim.lsp.config("phpactor", {
			capabilities = capabilities,
		})

		vim.lsp.config("prismals", {
			capabilities = capabilities,
		})

		vim.lsp.config("ruff", {
			capabilities = capabilities,
		})

		vim.lsp.config("smithy_ls", {
			capabilities = capabilities,
		})

		vim.lsp.config("sqlls", {
			capabilities = capabilities,
		})

		vim.lsp.config("standardrb", {
			capabilities = capabilities,
			-- TODO: Figure out at what version of standardrb the --lsp flag was added, so I can start using bundler installed version
			-- cmd = { "bundle", "exec", "standardrb", "--lsp" },
		})

		vim.lsp.config("tailwindcss", {
			capabilities = capabilities,
		})

		vim.lsp.config("terraformls", {
			capabilities = capabilities,
		})

		vim.lsp.config("tflint", {
			capabilities = capabilities,
		})

		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
		})

		vim.lsp.config("typos_lsp", {
			capabilities = capabilities,
			filetypes = { "markdown", "norg" },
			init_options = {
				config = "~/projects/dotfiles/typos/typos.toml",
			},
		})

		vim.lsp.config("vimls", {
			capabilities = capabilities,
		})

		vim.lsp.config("vue_ls", {
			capabilities = capabilities,
		})

		vim.lsp.config("vuels", {
			capabilities = capabilities,
			cmd = { "vue-language-server", "--stdio" },
		})

		vim.lsp.config("yamlls", {
			capabilities = capabilities,
		})

		vim.lsp.enable({
			"bashls",
			"basedpyright",
			"clangd",
			"clojure_lsp",
			"cssls",
			"cssmodules_ls",
			"cucumber_language_server",
			"denols",
			"docker_compose_language_service",
			"dockerls",
			"emmet_language_server",
			"eslint",
			"html",
			"jsonls",
			"lua_ls",
			"marksman",
			"phpactor",
			"prismals",
			"ruff",
			"smithy_ls",
			"sqlls",
			"standardrb",
			"tailwindcss",
			"terraformls",
			"tflint",
			"ts_ls",
			"typos_lsp",
			"vimls",
			"vue_ls",
			"vuels",
			"yamlls",
		})
	end,
}
