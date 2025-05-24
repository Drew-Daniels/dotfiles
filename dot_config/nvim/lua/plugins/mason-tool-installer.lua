return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		ensure_installed = {
			-- formatters (managed w/ mason-tool-installer)
      -- NOTE: Not installing through Mason since I'll want to install formatters through whatever primary package manager I'm using
			-- "ruff",
			-- "basedpyright",
			-- TODO: Install clang-format on NixOS
			-- "clang-format",
			-- "jsonlint",
			-- "stylua",
			-- "prettierd",
			-- "nxls",
			-- "shfmt",
			-- "shellcheck",
			-- "sqlfmt",
			-- "reformat-gherkin",
			-- "yamlfmt",
			-- LSPs (managed w/ mason-lspconfig)
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
			"smithy_ls",
			"marksman",
			"mutt-language-server",
			"tailwindcss",
			"terraformls",
			"tflint",
			"typos_lsp",
			"vimls",
			"yamlls",
			"ts_ls",
			"phpactor",
			"postgres_lsp",
			"prismals",
			"pylsp",
			-- "denols",
			"vue_ls",
			--TODO: Look into creating a PR to https://github.com/mason-org/mason-registry/ to add support for `nixd` instead
			"clojure_lsp",
			-- https://github.com/williamboman/mason-lspconfig.nvim/issues/451
			-- "cljfmt",
			-- linter
			-- https://github.com/williamboman/mason-lspconfig.nvim/issues/450
			-- "clj-kondo",
		},
	},
}
