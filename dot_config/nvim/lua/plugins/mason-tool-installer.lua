return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		ensure_installed = {
			-- "reformat-gherkin",
			-- LSPs (managed w/ mason-lspconfig)
			"clangd",
			"cssmodules_ls",
			"cucumber_language_server",
			"docker_compose_language_service",
			"emmet_language_server",
			"standardrb",
			"smithy_ls",
			"mutt-language-server",
			"vimls",
			"phpactor",
			"postgres_lsp",
			"prismals",
			--TODO: Look into creating a PR to https://github.com/mason-org/mason-registry/ to add support for `nixd` instead
			-- https://github.com/williamboman/mason-lspconfig.nvim/issues/451
			-- "cljfmt",
			-- https://github.com/williamboman/mason-lspconfig.nvim/issues/450
			-- "clj-kondo",
		},
	},
}
