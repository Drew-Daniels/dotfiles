local servers = {
	jsonls = {},
	html = {},
	clangd = {},
	cssmodules_ls = {},
	docker_compose_language_service = {},
	dockerls = {},
	emmet_language_server = {},
	yamlls = {},
	marksman = {},
	cucumber_language_server = {},
	tailwindcss = {},
	terraformls = {},
	smithy_ls = {},
	sqlls = {},
	vimls = {},
	phpactor = {},
	prismals = {},
	volar = {},
	nil_ls = {},
	clojure_lsp = {},
	ruff = {},
	basedpyright = {},
	tflint = {},
}

return {
	"neovim/nvim-lspconfig",
	config = function(_, _)
		local lspconfig = require("lspconfig")

		for server, config in pairs(servers) do
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
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

		-- lspconfig.denols.setup({
		-- 	root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
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
	end,
}
