require("plugins")

-- https://github.com/williamboman/mason.nvim/issues/130
local present, mason = pcall(require, "mason")

if not present then
	return
end

-- Not all dependencies installed by Mason here are specifically for nvim-lspconfig
-- some are installed here just for consistency across machines, and it's easier if
-- things are installed in one place.
local options = {
	ensure_installed = {
		"beautysh",
		"bash-language-server",
		"css-lsp",
		"cssmodules-language-server",
		"cucumber-language-server",
		"docker-compose-language-service",
		"dockerfile-language-server",
		"emmet-language-server",
		"eslint-lsp",
		"html-lsp",
		"json-lsp",
		"jsonlint",
		"rubocop",
		"lua-language-server",
		"solargraph",
		"stylua",
		"sqlls",
		"marksman",
		"tailwindcss-language-server",
		"vim-language-server",
		"yaml-language-server",
	},
	max_concurrent_installers = 10,
}

mason.setup(options)

vim.api.nvim_create_user_command("MasonInstallAll", function()
	vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
end, {})

require("dap").adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "9229",
	executable = {
		command = "node",
		args = { vim.fn.stdpath("data") .. "/vscode-js-debug", "9229" },
	},
}

-- https://miguelcrespo.co/posts/debugging-javascript-applications-with-neovim/

require("dap-vscode-js").setup({
	debugger_path = vim.fn.stdpath("data") .. "/vscode-js-debug",
	adapters = {
		"pwa-node",
		"pwa-chrome",
	},
})

local js_based_languages = { "typescript", "javascript", "typescriptreact" }

for _, language in ipairs(js_based_languages) do
	require("dap").configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-chrome",
			request = "launch",
			name = 'Start Chrome with "localhost"',
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
		},
	}
end

for _, language in ipairs({ "typescript", "javascript" }) do
	require("dap").configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
	}
end

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

-- custom file associations
require("vim.treesitter.language").register("http", "hurl")

require("neoscroll").setup({
	easing_function = "quadratic",
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
	"bashls",
	"cssls",
	"cssmodules_ls",
	"docker_compose_language_service",
	"dockerls",
	"emmet_language_server",
	"yamlls",
	"tsserver",
	"eslint",
	"marksman",
	"cucumber_language_server",
	"tailwindcss",
	"solargraph",
	"rubocop",
	"sqlls",
	"vimls",
}
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end

-- RECOMMENDED 'nvim-lspconfig' SETUP START
-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
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
		["<C-j>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		-- C-b (back) C-f (forward) for snippet placeholder navigation.
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
		}),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "neorg" },
	},
})

vim.o.updatetime = 250
vim.api.nvim_create_autocmd("CursorHold", {
	buffer = bufnr,
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})

-- RECOMMENDED 'nvim-lspconfig' SETUP END

-- luasnip specific configuration
-- specify luasnippets directory to save a few ms of startup time
require("luasnip.loaders.from_lua").load({ paths = "./luasnippets/" })

local ls = require("luasnip")

ls.config.set_config({
	-- Enable autotriggered snippets
	enable_autosnippets = false,

	-- Use Tab to trigger visual selection
	store_selection_keys = "<Tab>",

	-- show repeated node text as it's typed
	update_events = "TextChanged,TextChangedI",
})

vim.keymap.set({ "i" }, "<C-K>", function()
	ls.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function()
	ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function()
	ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

vim.keymap.set(
	"n",
	"<Leader>L",
	'<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "./luasnippets/"})<CR>',
	{ desc = "load snippets" }
)

ls.filetype_extend("javascriptreact", { "javascript" })

ls.filetype_extend("typescript", { "javascript" })

ls.filetype_extend("typescriptreact", { "javascriptreact" })

-- 'nvim-lsp' suggested keymappings, completion
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "open float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "goto prev" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "goto next" })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "set location list" })

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
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { unpack(opts), desc = "declaration" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { unpack(opts), desc = "definition" })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(opts), desc = "hover" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { unpack(opts), desc = "implementation" })
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { unpack(opts), desc = "signature help" })
		vim.keymap.set(
			"n",
			"<space>wa",
			vim.lsp.buf.add_workspace_folder,
			{ unpack(opts), desc = "add workspace folder" }
		)
		vim.keymap.set(
			"n",
			"<space>wr",
			vim.lsp.buf.remove_workspace_folder,
			{ unpack(opts), desc = "remove workspace folder" }
		)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { unpack(opts), desc = "list workspace folders" })
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, { unpack(opts), desc = "type definition" })
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { unpack(opts), desc = "rename" })
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { unpack(opts), desc = "code action" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { unpack(opts), desc = "references" })
		vim.keymap.set("n", "<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, { unpack(opts), desc = "format" })
	end,
})
-- 'nvim-dap' rec mappings
vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end, { desc = "continue" })
vim.keymap.set("n", "<F10>", function()
	require("dap").step_over()
end, { desc = "step over" })
vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end, { desc = "step into" })
vim.keymap.set("n", "<F12>", function()
	require("dap").step_out()
end, { desc = "step out" })
vim.keymap.set("n", "<Leader>b", function()
	require("dap").toggle_breakpoint()
end, { desc = "toggle breakpoint" })
vim.keymap.set("n", "<Leader>B", function()
	require("dap").set_breakpoint()
end, { desc = "set breakpoint" })
vim.keymap.set("n", "<Leader>lp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "log point message" })
vim.keymap.set("n", "<Leader>dr", function()
	require("dap").repl.open()
end, { desc = "open repl" })
vim.keymap.set("n", "<Leader>dl", function()
	require("dap").run_last()
end, { desc = "run last" })
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end, { desc = "hover" })
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end, { desc = "preview" })
vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, { desc = "frames" })
vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, { desc = "scopes" })
-- Language Server Configuration END

-- FZF
vim.keymap.set("n", "<Leader>j", ":GFiles<CR>", { noremap = false, desc = "Jump to Git Tracked File" })
vim.keymap.set("n", "<Leader>ja", ":FZF<CR>", { noremap = false, desc = "Jump to Any Tracked File" })
vim.keymap.set("n", "<Leader>g", ":RG<CR>", { noremap = false, desc = "Grep" })

-- my custom commands (not included in default 'fzf.vim' config)
vim.cmd(
	[[command! -bang -nargs=* Rgi call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case --iglob !yarn.lock --iglob !tags -- ".fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)]]
)

-- lualine
require("lualine").setup()

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		html = { "htmlbeautifier" },
		eruby = { "htmlbeaufifier" },
		fish = { "fish_indent" },
		json = { "jq" },
		sql = { "sql_formatter" },
	},
})

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

-- general configs
local set = vim.opt
set.smartindent = true
set.autoindent = true
set.expandtab = true
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.number = true
set.hlsearch = false
set.wildignore = "node_modules/*"
vim.cmd([[autocmd FileType * set formatoptions-=ro]])
set.syntax = "on"

-- neorg
-- set.conceallevel = 3
vim.keymap.set(
	"n",
	"<LocalLeader>lg",
	":Neorg keybind all core.looking-glass.magnify-code-block<CR>",
	{ desc = "Looking Glass" }
)

-- do not open folds when searching for text
vim.cmd([[set foldopen-=search]])

require("onedark").setup()

require("onedark").load()

require("capslock").setup()

-- Figure out how to update the image path used in markdown links. Images are getting copied to /images/<image-name> correctly, but the markdown links reference /img/<image-name>.
require("clipboard-image").setup({
	default = {
		img_dir = "images",
	},
})
-- vim.keymap.set({ "i", "c", "n" }, "<C-g>c", "<Plug>CapsLockToggle")
-- vim.keymap.set("i", "<C-l>", "<Plug>CapsLockToggle", { desc = "toggle caps lock" })

-- neogen https://github.com/danymat/neogen
require("neogen").setup({ snippet_engine = "luasnip" })

-- oil https://github.com/stevearc/oil.nvim
require("oil").setup()

-- zen-mode https://github.com/folke/zen-mode.nvim
require("zen-mode").setup({
	plugins = {
		tmux = {
			enabled = true,
		},
	},
})

-- overseer https://github.com/stevearc/overseer.nvim
require("overseer").setup()

vim.keymap.set("n", "<Leader>ot", ":OverseerToggle<CR>", { desc = "Overseer Toggle" })
vim.keymap.set("n", "<Leader>or", ":OverseerRun<CR>", { desc = "Overseer Run" })

vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", { noremap = true, silent = true })

-- harpoon
vim.keymap.set(
	"n",
	"<Leader>h",
	":lua require('harpoon.mark').add_file()<CR>",
	{ noremap = false, desc = "Harpoon file" }
)
vim.keymap.set(
	"n",
	"<Leader>s",
	":lua require('harpoon.ui').toggle_quick_menu()<CR>",
	{ noremap = false, desc = "Switch file" }
)
vim.keymap.set(
	"n",
	"<Leader>p",
	":lua require('harpoon.ui').nav_prev()<CR>",
	{ noremap = false, desc = "Navigate to Previous File" }
)
vim.keymap.set(
	"n",
	"<Leader>n",
	":lua require('harpoon.ui').nav_next()<CR>",
	{ noremap = false, desc = "Navigate to Next File" }
)
vim.keymap.set(
	"n",
	"<Leader>da",
	":lua require('harpoon.mark').clear_all()<CR>",
	{ noremap = false, desc = "Delete all Harpoons" }
)
