return {
	"neovim/nvim-lspconfig",
	-- Neovim 0.11+ provides default LSP keymaps:
	--   grn = rename, grr = references, gra = code action,
	--   gri = implementation, grt = type definition,
	--   gd = definition, gD = declaration, K = hover,
	--   <C-s> = signature help (insert mode)
	-- Additional LSP actions available via <leader>l* (which-key)
	config = function()
		-- Apply blink.cmp capabilities to all LSP servers
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		-- Individual server configs live in lsp/*.lua (Neovim 0.11+ auto-loads them).
		-- Only servers with custom settings need a file; the rest just need enabling.

		vim.lsp.enable({
			"ast_grep",
			"basedpyright",
			"bashls",
			"biome",
			"bzl",
			"clangd",
			"clojure_lsp",
			"cmake",
			"cssls",
			"cucumber_language_server",
			"cue",
			"dartls",
			"docker_compose_language_service",
			"dockerls",
			"emmet_language_server",
			"eslint",
			"fish_lsp",
			"gh_actions_ls",
			"gitlab_ci_ls",
			"golangci_lint_ls",
			"gopls",
			"graphql",
			"groovyls",
			"helm_ls",
			"html",
			"hyprls",
			"jsonls",
			"kulala_ls",
			"lemminx",
			"lua_ls",
			"marksman",
			"nickel_ls",
			"nil_ls",
			"nushell",
			"phpactor",
			"postgres_lsp",
			"ruff",
			"standardrb",
			"svelte",
			"tailwindcss",
			"taplo",
			"terraformls",
			"texlab",
			"tflint",
			"tinymist",
			"ts_ls",
			"turbo_ls",
			"typos_lsp",
			"vacuum",
			"vimls",
			"vue_ls",
			"vtsls",
			"yamlls",
			"zls",
		})
	end,
}
