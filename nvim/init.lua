require("plugins")
--TODO: Figure out why typing 'g', waiting, then 'cA' works to insert comments, but typing them all quickly doesn't?
-- Is there some plugin that is causing combinations that start with g to wait/not wait?

-- MASON
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
		"lua-language-server",
		"solargraph",
		"stylua",
		"sqlls",
		"marksman",
		"tailwindcss-language-server",
		"vim-language-server",
		"yaml-language-server",
		"typescript-language-server",
    "prettier",
	},
	max_concurrent_installers = 10,
}

mason.setup(options)

vim.api.nvim_create_user_command("MasonInstallAll", function()
	vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
end, {})

-- NVIM-DAP
-- https://github.com/mfussenegger/nvim-dap
require("dap").adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "9229",
	executable = {
		command = "node",
		args = { vim.fn.stdpath("data") .. "/vscode-js-debug", "9229" },
	},
}

-- DAP-VSCODE-JS
-- https://miguelcrespo.co/posts/debugging-javascript-applications-with-neovim/
---@diagnostic disable-next-line: missing-fields
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

-- NVIM-DAP-UI
-- https://github.com/rcarriga/nvim-dap-ui
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

-- TRANSPARENT.NVIM
-- https://github.com/xiyaowong/transparent.nvim
require("transparent").setup()

-- NVIM-TREESITTER
-- https://github.com/nvim-treesitter/nvim-treesitter
---@diagnostic disable-next-line: missing-fields
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
	-- required by 'nvim-ts-context-commentstring'
	context_commentstring = {
		enable = true,
	},
})

-- custom file associations
require("vim.treesitter.language").register("http", "hurl")

-- NEOSCROLL.NVIM
-- https://github.com/karb94/neoscroll.nvim
require("neoscroll").setup({
	easing_function = "quadratic",
})

-- WEB-TOOLS.NVIM
-- https://github.com/ray-x/web-tools.nvim
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

-- REST.NVIM
-- https://github.com/rest-nvim/rest.nvim
require("rest-nvim").setup({
	result_split_horizontal = false,
	result_split_in_place = true,
	skip_ssl_verification = false,
	encode_url = true,
	highlight = {
		enabled = true,
		timeout = 150,
	},
	result = {
		show_url = true,
		show_curl_command = false,
		show_http_info = true,
		show_headers = true,
		formatters = {
			json = "jq",
			html = function(body)
				return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
			end,
		},
	},
	jump_to_request = false,
	env_file = ".env",
	custom_dynamic_variables = {},
	yank_dry_run = true,
})

-- NEODEV.NVIM
-- https://github.com/folke/neodev.nvim
-- NOTE: must be done before any lspconfig
require("neodev").setup({})

--TODO: Figure out where this configuration was recommended?
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- NVIM-LSPCONFIG
-- https://github.com/neovim/nvim-lspconfig
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
	"eslint",
	"marksman",
	"cucumber_language_server",
	"tailwindcss",
	"solargraph",
	"sqlls",
	"vimls",
}
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end

-- RECOMMENDED 'nvim-lspconfig' SETUP
-- LUASNIP
-- https://github.com/L3MON4D3/LuaSnip
local luasnip = require("luasnip")

-- NVIM-CMP
-- https://github.com/hrsh7th/nvim-cmp
local cmp = require("cmp")
---@diagnostic disable-next-line: missing-fields
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
	},
})

--TODO: Where was this bit of configuration recommended?
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

--TODO: Better way to map these potentially?
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

ls.filetype_extend("javascriptreact", { "javascript" })
ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("typescriptreact", { "javascriptreact" })

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
		--TODO: Can I move these outside of this function?
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
		-- conform.nvim should handle formatting
		-- vim.keymap.set("n", "<space>f", function()
		-- 	vim.lsp.buf.format({ async = true })
		-- end, { unpack(opts), desc = "format" })
	end,
})
-- Language Server Configuration END

-- LUALINE
-- https://github.com/nvim-lualine/lualine.nvim
require("lualine").setup({
	sections = {
		lualine_x = {
			-- CAPSLOCK.NVIM
			-- https://github.com/barklan/capslock.nvim
			{ require("capslock").status_string },
		},
	},
})

-- CONFORM.NVIM
-- https://github.com/stevearc/conform.nvim
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		html = { "htmlbeautifier" },
		eruby = { "htmlbeaufifier" },
		fish = { "fish_indent" },
		json = { "jq" },
		sql = { "sql_formatter" },
    css = { "prettier" },
    less = { "prettier" },
    scss = { "prettier" },
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

-- ONEDARK.NVIM
-- https://github.com/navarasu/onedark.nvim
---@diagnostic disable-next-line: missing-parameter
require("onedark").setup()
require("onedark").load()

-- CLIPBOARD-IMAGE.NVIM
-- https://github.com/ekickx/clipboard-image.nvim
--TODO: Figure out how to update the image path used in markdown links. Images are getting copied to /images/<image-name> correctly, but the markdown links reference /img/<image-name>.
require("clipboard-image").setup({
	default = {
		img_dir = "images",
	},
})

-- NEOGEN
-- https://github.com/danymat/neogen
require("neogen").setup({ snippet_engine = "luasnip" })

-- OIL
-- https://github.com/stevearc/oil.nvim
require("oil").setup()

-- ZEN-MODE
-- https://github.com/folke/zen-mode.nvim
require("zen-mode").setup({
	plugins = {
		tmux = {
			enabled = true,
		},
	},
})

-- NVIM-TS-COMMENTSTRING
-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
---@diagnostic disable-next-line: missing-parameter
require("ts_context_commentstring").setup()

-- COMMENT.NVIM
-- https://github.com/numToStr/Comment.nvim
require("Comment").setup()

-- NVIM-NOTIFY
-- https://github.com/rcarriga/nvim-notify
---@diagnostic disable-next-line: missing-fields
require("notify").setup({
	background_colour = "#000000",
	render = "compact",
})

-- TELESCOPE.NVIM
-- https://github.com/nvim-telescope/telescope.nvim

-- WHICH-KEY.NVIM
-- https://github.com/folke/which-key.nvim
local wk = require("which-key")

wk.register({
	["<leader>"] = {
		t = {
			"<cmd>Telescope treesitter<cr>",
			"Treesitter",
		},
		i = {
			"<cmd>Telescope import<cr>",
			"Import",
		},
		p = {
			"<cmd>Format<cr>",
			"Pretty",
		},
	},
})

local d = require("dap")
local duiw = require("dap.ui.widgets")

-- CAPSLOCK.NVIM
-- https://github.com/barklan/capslock.nvim
require("capslock").setup()

-- vim.keymap.set({ "i", "c", "n" }, "<C-g>c", "<Plug>CapsLockToggle")
-- vim.keymap.set("i", "<C-l>", "<Plug>CapsLockToggle", { desc = "toggle caps lock" })

wk.register({
	["<leader>d"] = {
		name = "Debug",
		f = {
			function()
				duiw.centered_float(duiw.frames)
			end,
			"Frames",
		},
		h = {
			duiw.hover,
			"Hover",
		},
		p = {
			duiw.preview,
			"Preview",
		},
		s = {
			function()
				duiw.centered_float(duiw.scopes)
			end,
			"Scopes",
		},
		n = {
			d.set_breakpoint,
			"New Breakpoint",
		},
		t = {
			d.toggle_breakpoint,
			"Toggle Breakpoint",
		},
		c = {
			d.continue,
			"Continue",
		},
		v = {
			d.step_over,
			"Step Over",
		},
		u = {
			d.step_out,
			"Step Out",
		},
		r = {
			function()
				d.repl.open()
			end,
			"REPL",
		},
		l = {
			d.run_last,
			"Run Last",
		},
	},
})

wk.register({
	["<leader>e"] = {
		name = "Ex Commands",
		c = {
			"<cmd>Telescope commands<cr>",
			"Ex Commands",
		},
		h = {
			"<cmd>Telescope command_history<cr>",
			"Ex Command History",
		},
	},
})

-- HARPOON
-- https://github.com/ThePrimeagen/harpoon
local hui = require("harpoon.ui")
local hm = require("harpoon.mark")

wk.register({
	["<leader>f"] = {
		name = "Files",
		a = {
			"<cmd>Telescope autocommands<cr>",
			"Autocommands",
		},
		b = {
			"<cmd>Telescope buffers<cr>",
			"Buffer(s)",
		},
		d = {
			"<cmd>:lua require('harpoon.mark').clear_all()<cr>",
			"Delete All Harpoons",
		},
		f = {
			"<cmd>Telescope find_files<cr>",
			"File(s)",
		},
		g = {
			"<cmd>Telescope git_files<cr>",
			"Git-tracked File(s)",
		},
		i = {
			"<cmd>Telescope media_files<cr>",
			"Images & Media File(s)",
		},
		l = {
			"<cmd>Telescope resume<cr>",
			"Last Search Results",
		},
		o = {
			"<cmd>Oil<cr>",
			"Oil",
		},
		r = {
			"<cmd>Telescope oldfiles<cr>",
			"Recent File(s)",
		},
		t = {
			"<cmd>Telescope tags<cr>",
			"Tag",
		},
		c = { "<cmd>ene<cr>", "Create File" },
		m = { "<cmd>Telescope marks<cr>", "Marks" },
		q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
		h = { "<cmd>Telescope quickfix_history<cr>", "Quickfix History" },
		x = { hm.add_file, "Harpoon" },
		s = { hui.toggle_quick_menu, "Switch Harpoon" },
		p = { hui.nav_prev, "Previous Harpoon" },
		n = { hui.nav_next, "Next Harpoon" },
	},
})

wk.register({
	["<leader>g"] = {
		name = "Git",
		b = {
			"<cmd>Telescope git_branches<cr>",
			"Branches",
		},
		--TODO: Come back to this one
		-- b = {
		-- 	"<cmd>Telescope git_bcommits<cr>",
		-- 	"Buffer Commits",
		-- },
		c = {
			"<cmd>Telescope git_commits<cr>",
			"Commits",
		},
		r = {
			"<cmd>Telescope git_bcommits_range<cr>",
			"Range Buffer Commits",
		},
		s = {
			"<cmd>Telescope git_status<cr>",
			"Status",
		},
		w = {
			"<cmd>Telescope git_stash<cr>",
			"Work (Stashed)",
		},
	},
})

wk.register({
	["<leader>h"] = {
		name = "Help",
		h = {
			"<cmd>Telescope help_tags<cr>",
			"Help Tags",
		},
		o = {
			"<cmd>Telescope vim_options<cr>",
			"Vim Options",
		},
		s = {
			"<cmd>Telescope spell_suggest<cr>",
			"Open Recent File",
		},
		m = {
			"<cmd>Telescope man_pages<cr>",
			"Man Pages",
		},
	},
})

wk.register({
	["<leader>l"] = {
		name = "LSP",
		a = {
			-- code actions
		},
    b = {
      "<cmd>LspRestart<cr>",
      "Reboot LSP"
    },
		c = {
			-- change name
		},
		d = {
			"<cmd>Telescope diagnostics<cr>",
			"Diagnostics",
		},
		D = {
			-- definition
		},
		h = {
			-- hover
		},
		i = {
			"<cmd>Telescope lsp_implementations<cr>",
			"Implementations",
		},
		o = {
			vim.diagnostic.open_float,
			"Open Float",
		},
		l = { vim.diagnostic.setloclist, "Set Location List" },
		r = {
			"<cmd>Telescope lsp_references<cr>",
			"References",
		},
		R = {
			-- references
		},
		t = {
			"<cmd>Telescope lsp_type_definitions<cr>",
			"Type Definitions",
		},
		p = {
			vim.diagnostic.goto_prev,
			"Go-To Prev Diagnostic",
		},
		n = {
			vim.diagnostic.goto_next,
			"Go-To Next Diagnostic",
		},
		s = {
			-- signature_help
		},
	},
})

-- MARKDOWN-PREVIEW.NVIM
-- https://github.com/iamcco/markdown-preview.nvim
wk.register({
	["<leader>m"] = {
		name = "Markdown",
		p = {
			"<cmd>MarkdownPreview<cr>",
			"Markdown Preview",
		},
	},
})

wk.register({
	["<leader>r"] = {
		name = "Request",
		s = {
			"<Plug>RestNvim",
			"Send Request",
		},
		p = {
			"<Plug>RestNvimPreview",
			"Preview Request",
		},
		r = {
			"<Plug>RestNvimLast",
			"Repeat Last Request",
		},
	},
})

wk.register({
	["<leader>q"] = {
		name = "Query",
		l = {
			"<cmd>Telescope live_grep<cr>",
			"Live Search",
		},
		h = {
			"<cmd>Telescope search_history<cr>",
			"Search History",
		},
	},
})

-- OVERSEER.NVIM
-- https://github.com/stevearc/overseer.nvim
require("overseer").setup()

wk.register({
	["<leader>t"] = {
		name = "Tasks",
		t = {
			"<cmd>OverseerToggle<cr>",
			"Toggle",
		},
		r = { "<cmd>OverseerRun<cr>", "Run" },
	},
})

wk.register({
	["<leader>s"] = {
		name = "Snippets",
		-- NEOGEN
		-- https://github.com/danymat/neogen
		--TODO: More plugin-agnostic name possible here?
		n = {
			":lua require('neogen').generate()<CR>",
			"Neogen",
		},
		l = { '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "./luasnippets/"})<CR>', "Load" },
	},
}, { silent = true })

wk.register({
	["<leader>w"] = {
		name = "Workspace",
		a = {
			-- workspace add
		},
		r = {
			-- workspace remove
		},
		l = {
			-- workspace list
		},
	},
})

-- TELESCOPE-FZF-NATIVE
-- https://github.com/nvim-telescope/telescope-fzf-native.nvim
---@diagnostic disable-next-line: missing-parameter
require("telescope").setup({
	extensions = {
		import = {
			insert_at_top = true,
		},
	},
})
require("telescope").load_extension("fzf")

-- TELESCOPE-MEDIA-FILES.NVIM
-- https://github.com/nvim-telescope/telescope-media-files.nvim
require("telescope").load_extension("media_files")

-- GENERAL
local set = vim.opt
set.smartindent = true
set.autoindent = true
set.expandtab = true
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.ignorecase = true
set.smartcase = true
set.number = true
set.hlsearch = false
set.wildignore = "node_modules/*"
set.number = true
vim.cmd([[autocmd FileType * set formatoptions-=ro]])
set.syntax = "on"
-- do not open folds when searching for text
vim.cmd([[set foldopen-=search]])
