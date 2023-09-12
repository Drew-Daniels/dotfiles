require("plugins")
require("mason").setup()
require("mason-nvim-dap").setup({
	ensure_installed = { "firefox", "chrome" },
	handlers = {},
})

require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

require("nvim-tree").setup({
	filters = {
		exclude = { ".env", "node_modules" },
	},
})

require("tsc").setup()

require("transparent").setup()

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"bash",
		"css",
		"dockerfile",
		"fish",
		"html",
		"http",
		"javascript",
		"jq",
		"json",
		"markdown",
		"ruby",
		"scss",
		"sql",
		"toml",
		"tsx",
		"typescript",
		"yaml",
	},
	-- required by 'nvim-treesitter-endwise'
	endwise = {
		enable = true,
	},
})

require("web-tools").setup({
	keymaps = {
		rename = nil, -- by default use same setup of lspconfig
	},
	hurl = { -- hurl default
		show_headers = false, -- do not show http headers
		floating = false, -- use floating windows (need guihua.lua)
		formatters = { -- format the result by filetype
			json = { "jq" },
			html = { "prettier", "--parser", "html" },
		},
	},
})

require("rest-nvim").setup({
	-- Open request results in a horizontal split
	result_split_horizontal = false,
	-- Keep the http file buffer above|left when split horizontal|vertical
	result_split_in_place = true,
	-- Skip SSL verification, useful for unknown certificates
	skip_ssl_verification = false,
	-- Encode URL before making request
	encode_url = true,
	-- Highlight request on run
	highlight = {
		enabled = true,
		timeout = 150,
	},
	result = {
		-- toggle showing URL, HTTP info, headers at top the of result window
		show_url = true,
		-- show the generated curl command in case you want to launch
		-- the same request via the terminal (can be verbose)
		show_curl_command = false,
		show_http_info = true,
		show_headers = true,
		-- executables or functions for formatting response body [optional]
		-- set them to false if you want to disable them
		formatters = {
			json = "jq",
			html = function(body)
				return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
			end,
		},
	},
	-- Jump to request line on run
	jump_to_request = false,
	env_file = ".env",
	custom_dynamic_variables = {},
	yank_dry_run = true,
})

vim.keymap.set("n", "<leader>x", "<Plug>RestNvim", { desc = "execute request" })
vim.keymap.set("n", "<leader>p", "<Plug>RestNvimPreview", { desc = "preview curl" })
vim.keymap.set("n", "<leader>l", "<Plug>RestNvimLast", { desc = "repeat last request" })

-- 'neodev' configuration START - must be done before any lspconfig
require("neodev").setup({})
-- 'neodev' configuration END

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Language Server Configuration START
local lspconfig = require("lspconfig")

local servers = {
  "emmet_language_server",
	"lua_ls",
	"jsonls",
	"html",
	"cssls",
	"yamlls",
	"tsserver",
	"eslint",
	"cucumber_language_server",
	"tailwindcss",
}
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end

-- RECOMMENDED 'nvim-lspconfig' SETUP START
-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmpsetup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
		["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
		-- C-b (back) C-f (forward) for snippet placeholder navigation.
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})
-- RECOMMENDED 'nvim-lspconfig' SETUP END

-- 'nvim-lsp' suggested keymappings, completion
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})
-- 'nvim-dap' rec mappings
vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
	require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>b", function()
	require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
	require("dap").set_breakpoint()
end)
vim.keymap.set("n", "<Leader>lp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dr", function()
	require("dap").repl.open()
end)
vim.keymap.set("n", "<Leader>dl", function()
	require("dap").run_last()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end)
-- Language Server Configuration END

-- FZF
vim.keymap.set("n", "<C-p>", ":FZF<CR>", { noremap = false })

-- lualine
require("lualine").setup()

-- general configs
local set = vim.opt
set.autoindent = true
set.expandtab = true
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.number = true
set.hlsearch = false
vim.cmd([[autocmd FileType * set formatoptions-=ro]])
set.syntax = "on"

vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<CR>", { desc = "source init.lua" })

require("onedark").setup({
	style = "darker",
})

require("onedark").load()

local function open_nvim_tree()
	-- open the tree
	require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
