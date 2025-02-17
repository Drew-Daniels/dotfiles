return {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		automatic_installation = false,
		ensure_installed = {
			"bashls",
			"clangd",
			"cssls",
			"cssmodules_ls",
			"cucumber_language_server",
			"docker_compose_language_service",
			"dockerls",
			"emmet_language_server",
			"eslint",
			"html",
			"jsonls",
			"lua_ls",
			"sqlls",
			"standardrb",
			"marksman",
			"tailwindcss",
			"terraformls",
			"tflint",
			"typos_lsp",
			"vimls",
			"yamlls",
			"ts_ls",
			"prismals",
			"pylsp",
			"denols",
			"volar",
			--TODO: Look into creating a PR to https://github.com/mason-org/mason-registry/ to add support for `nixd` instead
			-- "nil_ls",
			"clojure_lsp",
			-- https://github.com/williamboman/mason-lspconfig.nvim/issues/451
			-- "cljfmt",
			-- linter
			-- https://github.com/williamboman/mason-lspconfig.nvim/issues/450
			-- "clj-kondo",
			"ruff",
			"basedpyright",
		},
	},
}
