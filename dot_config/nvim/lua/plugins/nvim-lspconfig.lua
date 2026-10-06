return {
	"neovim/nvim-lspconfig",
	init = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { unpack(opts), desc = "declaration" })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { unpack(opts), desc = "definition" })
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(opts), desc = "hover" })
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { unpack(opts), desc = "implementation" })
				vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { unpack(opts), desc = "signature help" })
				vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { unpack(opts), desc = "type definition" })
				vim.keymap.set("n", "gr", vim.lsp.buf.references, { unpack(opts), desc = "references" })
				vim.keymap.set("n", "gR", vim.lsp.buf.rename, { unpack(opts), desc = "rename" })
			end,
			desc = "Initialize LSP on LspAttach event",
		})
	end,
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
