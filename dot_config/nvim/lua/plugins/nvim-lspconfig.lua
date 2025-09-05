return {
	"neovim/nvim-lspconfig",
	config = function(_, _)
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		-- TODO: Modularize configuration so that 'capabilities = capabilities' setting is used for every lsp
		--TODO: Deactivate eslint lsp when in an "ignored" directory so things are less noisy
		-- https://github.com/neovim/nvim-lspconfig/issues/2508
		local root_dir = vim.fs.root(0, ".git")
		local use_flat_config = false
		if root_dir ~= nil and vim.fn.filereadable(root_dir .. "/eslint.config.js") == 1 then
			use_flat_config = true
		end

		vim.lsp.config("ast_grep", {
			capabilities = capabilities,
		})

		vim.lsp.config("biome", {
			capabilities = capabilities,
		})

		vim.lsp.config("clangd", {
			capabilities = capabilities,
		})

		vim.lsp.config("kotlin_lsp", {
			capabilities = capabilities,
		})

		-- NOTE: Commenting out because no Nixpkgs for these language servers
		-- vim.lsp.config("clangd", {
		-- 	capabilities = capabilities,
		-- })

		-- vim.lsp.config("cssmodules_ls", {
		-- 	capabilities = capabilities,
		-- })
		--
		-- vim.lsp.config("cucumber_language_server", {
		-- 	capabilities = capabilities,
		-- })

		vim.lsp.config("emmet_language_server", {
			capabilities = capabilities,
		})

		vim.lsp.config("phpactor", {
			capabilities = capabilities,
		})

		-- vim.lsp.config("prismals", {
		-- 	capabilities = capabilities,
		-- })
		-- vim.lsp.config("smithy_ls", {
		-- 	capabilities = capabilities,
		-- })
		vim.lsp.config("standardrb", {
			capabilities = capabilities,
			-- TODO: Figure out at what version of standardrb the --lsp flag was added, so I can start using bundler installed version
			-- cmd = { "bundle", "exec", "standardrb", "--lsp" },
		})
		--
		-- vim.lsp.config("mutt-language-server", {
		--   capabilities = capabilities,
		-- })

		-- vim.lsp.config("postgrestools", {
		-- capabilities = capabilities,
		-- })

		vim.lsp.config("vimls", {
			capabilities = capabilities,
		})

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

		-- TODO: Figure out how to get denols to only attach when root_marker file found. Keeps attaching even when not the case
		-- vim.lsp.config("denols", {
		-- 	capabilities = capabilities,
		-- 	root_markers = { "deno.json", "deno.jsonc" },
		-- 	init_options = {
		-- 		lint = true,
		-- 		suggest = {
		-- 			imports = {
		-- 				hosts = {
		-- 					["https://deno.land"] = true,
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		-- })

		-- https://docs.deno.com/runtime/getting_started/setup_your_environment/#neovim-0.6%2B-using-the-built-in-language-server
		vim.lsp.config("ts_ls", {
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
						-- TODO: Look at adding javascriptreact and typescriptreact as additional filestypes
						languages = { "javascript", "typescript", "vue" },
					},
				},
			},
			root_markers = { "package.json" },
			single_file_support = false,
		})

		vim.lsp.config("dockerls", {
			capabilities = capabilities,
		})

		vim.lsp.config("docker_compose_language_service", {
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

		vim.lsp.config("gopls", {
			capabilities = capabilities,
		})

		vim.lsp.config("golangci_lint_ls", {
			capabilities = capabilities,
		})

		vim.lsp.config("html", {
			capabilities = capabilities,
		})

		vim.lsp.config("kulala_ls", {
			capabilities = capabilities,
		})

		vim.lsp.config("hyprls", {
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

		vim.lsp.config("ruff", {
			capabilities = capabilities,
		})

		-- NOTE: Commenting out because rustaceanvim handles configuration
		-- vim.lsp.config("rust_analyzer", {
		-- 	capabilities = capabilities,
		-- })

		vim.lsp.config("sqls", {
			capabilities = capabilities,
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

		vim.lsp.config("typos_lsp", {
			capabilities = capabilities,
			filetypes = { "markdown", "norg" },
			init_options = {
				config = "~/projects/dotfiles/typos/typos.toml",
			},
		})

		vim.lsp.config("taplo", {
			capabilities = capabilities,
		})

		vim.lsp.config("vue_ls", {
			capabilities = capabilities,
		})

		vim.lsp.config("yamlls", {
			capabilities = capabilities,
		})

		vim.lsp.config("nil_ls", {
			capabilities = capabilities,
			settings = {
				["nil"] = {
					formatting = {
						command = { "nixfmt" },
					},
				},
			},
		})

		vim.lsp.config("nickel_ls", {
			capabilities = capabilities,
		})

		vim.lsp.config("zls", {
			capabilities = capabilities,
		})

		vim.lsp.enable({
			"ast_grep",
			"biome",
			-- TODO: Install clang-tools package on NixOS: https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=clang-tools
			-- https://weblog.zamazal.org/sw-problem-lsp-c-nixos/
			"clangd",
			-- "cssmodules_ls",
			"docker_compose_language_service",
			"emmet_language_server",
			"phpactor",
			-- "prismals",
			-- "smithy_ls",
			"vimls",
			-- "cucumber_language_server",
			"bashls",
			-- Disabling for now since I hardly use Python, and when I do, this gets noisy
			-- "basedpyright",
			"clojure_lsp",
			"cssls",
			"taplo",
			"ts_ls",
			-- "denols",
			"dockerls",
			"eslint",
			"gopls",
			"golangci_lint_ls",
			"html",
			"hyprls",
			"jsonls",
			"kotlin_lsp",
			"kulala_ls",
			"lua_ls",
			"marksman",
			"ruff",
			-- NOTE: Commenting out bc rustaceanvim handles enabling this
			-- "rust_analyzer",
			"sqls",
			"standardrb",
			"tailwindcss",
			"terraformls",
			"tflint",
			"typos_lsp",
			"vue_ls",
			"yamlls",
			-- TODO: Only enable nil_ls when on nixos
			"nil_ls",
			"nickel_ls",
			"zls",
		})
	end,
}
