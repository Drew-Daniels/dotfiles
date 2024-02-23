require("plugins")
--TODO: Figure out why typing 'g', waiting, then 'cA' works to insert comments, but typing them all quickly doesn't?
-- Is there some plugin that is causing combinations that start with g to wait/not wait?

require("legendary").setup({
	extensions = { lazy_nvim = { auto_register = true }, which_key = { auto_register = true }, smart_splits = {} },
})

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
		"bash-language-server",
		"clangd",
		"clang-format",
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
		"prisma-language-server",
		"graphql-language-service-cli",
		"firefox-debug-adapter",
		"chrome-debug-adapter",
		"js-debug-adapter",
		"nxls",
	},
	max_concurrent_installers = 10,
}

mason.setup(options)

vim.api.nvim_create_user_command("MasonInstallAll", function()
	vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
end, {})

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
		"markdown_inline",
		"ruby",
		"scss",
		"sql",
		"toml",
		"tsx",
		"typescript",
		"yaml",
		"prisma",
	},
	-- required by 'nvim-treesitter-endwise'
	endwise = {
		enable = true,
	},
	-- NVIM-TREESITTER-TEXTOBJECTS
	-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	textobjects = {
		lsp_interop = {
			enable = true,
			border = "none",
			floating_preview_opts = {},
			peek_definition_code = {
				["<leader>vf"] = "@function.outer",
				["<leader>vc"] = "@class.outer",
			},
		},
		move = {
			--TODO: Figure out why go-tos for conditionals don't work in .rb files?
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = { query = "@function.outer", desc = "Next method (start)" },
				["]c"] = { query = "@class.outer", desc = "Next class (start)" },
				["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope (start)" },
				["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold (start)" },
				["]d"] = { query = "@conditional.outer", desc = "Next Conditional (start)" },
			},
			goto_next_end = {
				["]M"] = { query = "@function.outer", desc = "Next method (end)" },
				["]C"] = { query = "@class.outer", desc = "Next class (end)" },
				["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope (end)" },
				["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold (end)" },
				["]D"] = { query = "@conditional.outer", desc = "Next Conditional (end)" },
			},
			goto_previous_start = {
				["[m"] = { query = "@function.outer", desc = "Previous method (start)" },
				["[c"] = { query = "@class.outer", desc = "Previous class (start)" },
				["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope (start)" },
				["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold (start)" },
				["[d"] = { query = "@conditional.outer", desc = "Previous Conditional (start)" },
			},
			goto_previous_end = {
				["[M"] = { query = "@function.outer", desc = "Previous method (end)" },
				["[C"] = { query = "@class.outer", desc = "Previous class (end)" },
				["[S"] = { query = "@scope", query_group = "locals", desc = "Previous scope (end)" },
				["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold (end)" },
				["[D"] = { query = "@conditional.outer", desc = "Previous Conditional (end)" },
			},
		},
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = { query = "@function.outer", desc = "Select outer function" },
				["if"] = { query = "@function.inner", desc = "Select inner function" },
				["ac"] = { query = "@class.outer", desc = "Select outer class" },
				["ic"] = { query = "@class.inner", desc = "Select inner class" },
				["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
				["is"] = { query = "@scope.inner", query_group = "locals", desc = "Select inner language scope" },
				["al"] = { query = "@loop.outer", desc = "Select outer loop" },
				["il"] = { query = "@loop.inner", desc = "Select inner loop" },
				["ab"] = { query = "@block.outer", desc = "Select outer block" },
				--TODO: Figure out how to select blocks without the curly braces
				["ib"] = { query = "@block.inner", desc = "Select inner block", kind = "exclusive" },
				["ad"] = { query = "@conditional.outer", desc = "Select outer conditional" },
				["id"] = { query = "@conditional.inner", desc = "Select inner conditional" },
				["ap"] = { query = "@parameter.outer", desc = "Select outer parameter" },
				["ip"] = { query = "@parameter.inner", desc = "Select inner parameter" },
				["aP"] = { query = "@parameter.outer", mode = "a", desc = "Select outer parameter (inclusive)" },
				["iP"] = { query = "@parameter.inner", mode = "a", desc = "Select inner parameter (inclusive)" },
				["a,"] = { query = "@parameter.outer", mode = "i", desc = "Select outer parameter (exclusive)" },
				["i,"] = { query = "@parameter.inner", mode = "i", desc = "Select inner parameter (exclusive)" },
				["a;"] = {
					query = "@parameter.outer",
					mode = "a",
					kind = "inclusive",
					desc = "Select outer parameter (inclusive)",
				},
				["i;"] = {
					query = "@parameter.inner",
					mode = "a",
					kind = "inclusive",
					desc = "Select inner parameter (inclusive)",
				},
				["a:"] = {
					query = "@parameter.outer",
					mode = "i",
					kind = "exclusive",
					desc = "Select outer parameter (exclusive)",
				},
				["i:"] = {
					query = "@parameter.inner",
					mode = "i",
					kind = "exclusive",
					desc = "Select inner parameter (exclusive)",
				},
				["a/"] = { query = "@comment.outer", desc = "Select outer comment" },
				["i/"] = { query = "@comment.inner", desc = "Select inner comment" },
				["a#"] = {
					query = "@comment.outer",
					mode = "i",
					kind = "inclusive",
					desc = "Select outer comment (inclusive)",
				},
				["i#"] = {
					query = "@comment.inner",
					mode = "i",
					kind = "inclusive",
					desc = "Select inner comment (inclusive)",
				},
			},
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "V", -- blockwise
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
		},
	},
	-- my config
	highlight = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			--TODO: how to inform whichkey that <leader>s should be used for this?
			init_selection = "<Leader>si", -- select start
			node_incremental = "<Leader>sn", -- select node (incremental)
			scope_incremental = "<Leader>ss", -- select scope
			node_decremental = "<Leader>sd", -- select node (decremental)
		},
	},
	indent = {
		enable = true,
	},
})

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

-- This repeats the last query with always previous direction and to the start of the range.
vim.keymap.set({ "n", "x", "o" }, "<home>", function()
	ts_repeat_move.repeat_last_move({ forward = false, start = true })
end)

-- This repeats the last query with always next direction and to the end of the range.
vim.keymap.set({ "n", "x", "o" }, "<end>", function()
	ts_repeat_move.repeat_last_move({ forward = true, start = false })
end)

-- custom file associations
require("vim.treesitter.language").register("http", "hurl")

-- NEOSCROLL.NVIM
-- https://github.com/karb94/neoscroll.nvim
local t = {}
t["<C-k>"] = { "scroll", { "-vim.wo.scroll", "true", "350" } }
t["<C-j>"] = { "scroll", { "vim.wo.scroll", "true", "350" } }
t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "500" } }
t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "500" } }
t["<C-y>"] = { "scroll", { "-0.10", "false", "100" } }
--TODO: Find better keymapping for this since this gets overridden by change choice for luasnip
t["<C-e>"] = { "scroll", { "0.10", "false", "100" } }
t["zt"] = { "zt", { "0" } }
t["zz"] = { "zz", { "0" } }
t["zb"] = { "zb", { "0" } }

require("neoscroll").setup({
	easing_function = "quadratic",
})

require("neoscroll.config").set_mappings(t)

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
	"jsonls",
	"html",
	"bashls",
	"clangd",
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
	"prismals",
	"graphql",
	-- turning off for now: https://github.com/nrwl/nx-console/issues/2019
	-- "nxls",
}
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- RECOMMENDED 'nvim-lspconfig' SETUP
-- LUASNIP
-- https://github.com/L3MON4D3/LuaSnip
local ls = require("luasnip")

-- NVIM-CMP
-- https://github.com/hrsh7th/nvim-cmp
local cmp = require("cmp")
---@diagnostic disable-next-line: missing-fields
cmp.setup({
	snippet = {
		expand = function(args)
			ls.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-p>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	}),
	sources = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
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

ls.config.set_config({
	-- Enable autotriggered snippets
	enable_autosnippets = false,
	-- Use Tab to trigger visual selection
	store_selection_keys = "<Tab>",
	-- show repeated node text as it's typed
	update_events = "TextChanged,TextChangedI",
})

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	ls.jump(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-h>", function()
	ls.jump(-1)
end, { silent = true })

--TODO: Why do I have to hit <C-e> twice to expand?
vim.keymap.set({ "i" }, "<C-e>", function()
	ls.expand()
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-c>", function()
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
		-- commenting this out since nvim-treesitter-textobject providers more consistent TypeScript support for peeking definitions
		-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(opts), desc = "hover" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { unpack(opts), desc = "implementation" })
		vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { unpack(opts), desc = "signature help" })
		vim.keymap.set(
			"n",
			"<leader>wa",
			vim.lsp.buf.add_workspace_folder,
			{ unpack(opts), desc = "add workspace folder" }
		)
		vim.keymap.set(
			"n",
			"<leader>wr",
			vim.lsp.buf.remove_workspace_folder,
			{ unpack(opts), desc = "remove workspace folder" }
		)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { unpack(opts), desc = "list workspace folders" })
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { unpack(opts), desc = "type definition" })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { unpack(opts), desc = "rename" })
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { unpack(opts), desc = "code action" })
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
	options = { theme = "gruvbox" },
	sections = {
		lualine_x = {
			-- CAPSLOCK.NVIM
			-- https://github.com/barklan/capslock.nvim
			-- { require("capslock").status_string },
			{ "overseer" },
		},
	},
})

-- CONFORM.NVIM
-- https://github.com/stevearc/conform.nvim
require("conform").setup({
	formatters_by_ft = {
		c = { "clang-format" },
		lua = { "stylua" },
		html = { "htmlbeautifier" },
		eruby = { "htmlbeaufifier" },
		fish = { "fish_indent" },
		json = { "jq" },
		sql = { "sql_formatter" },
		css = { "prettier" },
		less = { "prettier" },
		scss = { "prettier" },
		zsh = { "shfmt" },
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

-- GRUVBOX-NVIM
-- https://github.com/ellisonleao/gruvbox.nvim
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

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

require("telescope").load_extension("notify")

-- TELESCOPE-IMPORT
-- https://github.com/piersolenski/telescope-import.nvim
require("telescope").load_extension("import")

-- TELESCOPE-MEDIA-FILES
-- https://github.com/nvim-telescope/telescope-media-files.nvim
require("telescope").load_extension("media_files")
require("telescope").setup({
	extensions = { media_files = { file_types = { "png", "jpg", "jpeg", "mp4", "webm", "pdf" }, find_cmd = "rg" } },
})

-- TELESCOPE-DAP
-- https://github.com/nvim-telescope/telescope-dap.nvim
require("telescope").load_extension("dap")

-- OVERSEER.NVIM
-- https://github.com/stevearc/overseer.nvim
require("overseer").setup({
	templates = { "builtin", "gitlab.gll" },
})

-- WHICH-KEY.NVIM
-- https://github.com/folke/which-key.nvim
local wk = require("which-key")

-- weird workaround to fix bug where which-key menu does not display unless <leader> has been pressed on a buffer at some point before pressing <localleader>
-- https://github.com/folke/which-key.nvim/issues/172
vim.keymap.set({ "n" }, "<localleader>", function()
	wk.show("<localleader>", { mode = "n" })
end, { silent = true })

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

-- CAPSLOCK.NVIM
-- https://github.com/barklan/capslock.nvim
require("capslock").setup()

-- vim.keymap.set({ "i", "c", "n" }, "<C-g>c", "<Plug>CapsLockToggle")
-- vim.keymap.set("i", "<C-l>", "<Plug>CapsLockToggle", { desc = "toggle caps lock" })
wk.register({
	["<leader>c"] = {
		name = "Copilot",
		d = { "<cmd>Copilot disable<cr>", "Disable" },
		e = { "<cmd>Copilot enable<cr>", "Enable" },
		s = { "<cmd>Copilot status<cr>", "Status" },
	},
})

wk.register({
	["<leader>d"] = {
		name = "Debug",
		b = {
			require("dap").set_breakpoint,
			"Breakpoint",
		},
		c = { require("dap").continue, "Continue (Start)" },
		d = {
			require("dap").continue,
			"Debug",
		},
		f = {
			function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end,
			"Frames",
		},
		h = {
			function()
				local widgets = require("dap.ui.widgets")
				widgets.hover()
			end,
			"Hover",
		},
		l = {
			require("dap").run_last,
			"Run Last",
		},
		p = {
			function()
				local widgets = require("dap.ui.widgets")
				widgets.preview()
			end,
			"Preview",
		},
		r = {
			function()
				require("dap").repl.open()
			end,
			"REPL",
		},
		s = {
			function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end,
			"Scopes",
		},
		t = {
			require("dap").toggle_breakpoint,
			"Toggle Breakpoint",
		},
		u = {
			require("dap").step_out,
			"Step Out",
		},
		v = {
			require("dap").step_over,
			"Step Over",
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

-- HARPOON
-- https://github.com/ThePrimeagen/harpoon
local hui = require("harpoon.ui")
local hm = require("harpoon.mark")

wk.register({
	["<leader>a"] = {
		name = "API Request",
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
	["<leader>h"] = {
		name = "Harpoon",
		a = { hm.add_file, "Add Harpoon" },
		d = {
			"<cmd>:lua require('harpoon.mark').clear_all()<cr>",
			"Delete All Harpoons",
		},
		s = { hui.toggle_quick_menu, "Switch Harpoon" },
		p = { hui.nav_prev, "Previous Harpoon" },
		n = { hui.nav_next, "Next Harpoon" },
	},
})

wk.register({
	["<leader>j"] = {
		name = "Jump",
		d = {
			":cd %:p:h<cr>",
			"Directory",
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
			"Reboot LSP",
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
	["<leader>n"] = {
		name = "Neogen",
		g = {
			":lua require('neogen').generate()<CR>",
			"Generate",
		},
		f = {
			":lua require('neogen').generate({ type = 'func' })<CR>",
			"Generate Function Annotation",
		},
		c = {
			":lua require('neogen').generate({ type = 'class' })<CR>",
			"Generate Class Annotation",
		},
		t = {
			":lua require('neogen').generate({ type = 'type' })<CR>",
			"Generate Type Annotation",
		},
	},
})

wk.register({
	["<leader>o"] = {
		name = "Overseer",
		t = {
			"<cmd>OverseerToggle<cr>",
			"Toggle",
		},
		c = {
			"<cmd>OverseerClose<cr>",
			"Close",
		},
		o = {
			"<cmd>OverseerOpen<cr>",
			"Open",
		},
		i = {
			"<cmd>OverseerInfo<cr>",
			"Info",
		},
		r = {
			"<cmd>OverseerRun<cr>",
			"Run",
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

wk.register({
	["<leader>t"] = {
		name = "Test",
		b = {
			':lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
			"Buffer",
		},
		s = {
			':lua require("neotest").run.run(vim.fn.getcwd())<CR>',
			"Suite",
		},
		f = {
			':lua require("neotest").run.run()<CR>',
			"Function",
		},
	},
})

wk.register({
	["<leader>u"] = {
		name = "Undotree",
		t = { "<cmd>UndotreeToggle<cr>", "Toggle" },
		f = { "<cmd>UndotreeFocus<cr>", "Focus" },
		s = { "<cmd>UndotreeShow<cr>", "Show" },
		h = { "<cmd>UndotreeHide<cr>", "Hide" },
		p = { "<cmd>UndotreePersistUndo<cr>", "PersistUndo" },
	},
})

wk.register({
	["<leader>S"] = {
		name = "Snippets",
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
-- NEOTEST-RSPEC
-- https://github.com/olimorris/neotest-rspec

--TODO: Figure out how to run ahoy rspec when running tests from work comp, but use default command when running tests from home comp.
-- require("neotest-rspec")({
--   rspec_cmd = function()
--     return vim.tbl_flatten({ "ahoy", "rspec" })
--   end
-- })

require("neotest").setup({
	adapters = {
		require("neotest-rspec"),
		require("neotest-jest")({
			jestCommand = "yarn test",
			jestConfigFile = "jest.config.js",
			cwd = function()
				return vim.fn.getcwd()
			end,
		}),
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

-- INDENT-BLANKLINE.NVIM
-- https://github.com/lukas-reineke/indent-blankline.nvim
require("ibl").setup()

-- NVIM-DAP
-- https://github.com/mfussenegger/nvim-dap
local dap = require("dap")

-- NVIM-DAP-VSCODE-JS
-- https://github.com/mxsdev/nvim-dap-vscode-js
require("dap-vscode-js").setup({
	adapters = { "pwa-node", "pwa-chrome", "node-terminal", "pwa-extensionHost" },
	debugger_path = vim.fn.stdpath("data") .. "/vscode-js-debug",
})

for _, language in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
	require("dap").configurations[language] = {
		{
			name = "Launch file",
			type = "pwa-node",
			request = "launch",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			name = "Attach",
			type = "pwa-node",
			request = "attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			name = "Debug Jest Tests",
			type = "pwa-node",
			request = "launch",
			-- trace = true, -- include debugger info
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/jest/bin/jest.js",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
		{
			name = "Debug Admin",
			type = "pwa-chrome",
			request = "launch",
			url = "http://localhost:3002",
			webRoot = "${workspaceFolder}",
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			name = "Debug PT/Embedded",
			type = "pwa-chrome",
			request = "launch",
			url = "http://localhost:3003",
			webRoot = "${workspaceFolder}",
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			name = "Debug Patient",
			type = "pwa-chrome",
			request = "launch",
			url = "http://localhost:3001",
			webRoot = "${workspaceFolder}",
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
		},
	}
end

-- vim.keymap.set("n", "<F5>", function()
-- 	require("dap").continue()
-- end)
-- vim.keymap.set("n", "<F10>", function()
-- 	require("dap").step_over()
-- end)
-- vim.keymap.set("n", "<F11>", function()
-- 	require("dap").step_into()
-- end)
-- vim.keymap.set("n", "<F12>", function()
-- 	require("dap").step_out()
-- end)
-- vim.keymap.set("n", "<Leader>b", function()
-- 	require("dap").toggle_breakpoint()
-- end)
-- vim.keymap.set("n", "<Leader>B", function()
-- 	require("dap").set_breakpoint()
-- end)
-- vim.keymap.set("n", "<Leader>lp", function()
-- 	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
-- end)
-- vim.keymap.set("n", "<Leader>dr", function()
-- 	require("dap").repl.open()
-- end)
-- vim.keymap.set("n", "<Leader>dl", function()
-- 	require("dap").run_last()
-- end)
-- vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
-- 	require("dap.ui.widgets").hover()
-- end)
-- vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
-- 	require("dap.ui.widgets").preview()
-- end)
-- vim.keymap.set("n", "<Leader>df", function()
-- 	local widgets = require("dap.ui.widgets")
-- 	widgets.centered_float(widgets.frames)
-- end)
-- vim.keymap.set("n", "<Leader>ds", function()
-- 	local widgets = require("dap.ui.widgets")
-- 	widgets.centered_float(widgets.scopes)
-- end)

-- NVIM-DAP-UI
-- https://github.com/rcarriga/nvim-dap-ui
require("dapui").setup()
local dapui = require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close({})
end

-- SMART-SPLITS.NVIM
-- https://github.com/mrjones2014/smart-splits.nvim?tab=readme-ov-file
require("smart-splits").setup({
	resize_mode = { hooks = { on_leave = require("bufresize").register } },
})

-- NEORG
-- https://github.com/nvim-neorg/neorg
require("neorg").setup({
	load = {
		["core.defaults"] = {}, -- Loads default behaviour
		["core.concealer"] = {}, -- Adds pretty icons to your documents
		["core.dirman"] = { -- Manages Neorg workspaces
			config = {
				workspaces = {
					su = "~/projects/work_notes/su/2024",
					ooo = "~/projects/work_notes/ooo/2024",
					home = "~/projects/home_notes",
				},
			},
		},
		["core.keybinds"] = { config = { default_keybinds = {} } },
		["core.completion"] = {
			config = {
				engine = "nvim-cmp",
			},
		},
	},
})

vim.api.nvim_create_user_command("Note", function(opts)
	local name = opts.fargs[1]
	vim.cmd("e ~/projects/home_notes/" .. name .. ".norg")
end, { range = false, nargs = 1 })

vim.api.nvim_create_user_command("Standup", function(opts)
	local date = os.date("%Y-%m-%d")
	if opts.fargs[1] == "yesterday" then
		date = os.date("%Y-%m-%d", os.time() - 86400)
	elseif opts.fargs[1] == "today" then
		date = os.date("%Y-%m-%d")
	--TODO: Figure out how to create a SU note for the next Monday if current day is Friday
	elseif opts.fargs[1] == "tomorrow" then
		date = os.date("%Y-%m-%d", os.time() + 86400)
	elseif opts.fargs[1] == "monday" then
		date = os.date("%Y-%m-%d", os.time() + 86400 * (8 - os.date("%w")))
	else
		print("Invalid date")
		return
	end
	vim.cmd("e ~/projects/work_notes/su/2024/" .. date .. ".norg")
end, { range = false, nargs = 1 })

vim.api.nvim_create_user_command("Ticket", function(opts)
	local ticket_no = opts.fargs[1]
	local desc = opts.fargs[2]
	if tonumber(ticket_no) == nil then
		print("Invalid ticket")
		return
	end
	if type(desc) ~= "string" then
		print("Invalid ticket description")
		return
	end
	vim.cmd("e ~/projects/work_notes/tickets/KEET-" .. ticket_no .. "-" .. desc .. ".norg")
end, { nargs = "*" })

--TODO: Create a 'OOO' command to create One on One files

vim.cmd([[
  augroup neorg_cmds
    autocmd BufNewFile ~/projects/work_notes/su/**/*.norg 0read ~/projects/dotfiles/nvim/norg/templates/standup_template.norg
    autocmd BufNewFile ~/projects/work_notes/ooo/**/*.norg 0read ~/projects/dotfiles/nvim/norg/templates/ooo_template.norg
    autocmd FileType norg setlocal conceallevel=3
    " Figure out how to stop folds from getting created on buffers created after first entering into a .norg buffer
    autocmd BufWritePost ~/projects/work_notes/su/**/*.norg silent !git -C ~/projects/work_notes/su/ add . && git -C ~/projects/work_notes/su/ commit -m "Update work notes" && git -C ~/projects/work_notes/su/ push
    autocmd BufWritePost ~/projects/work_notes/ooo/**/*.norg silent !git -C ~/projects/work_notes/ooo/ add . && git -C ~/projects/work_notes/ooo/ commit -m "Update work notes" && git -C ~/projects/work_notes/ooo/ push
    " Figure out why recursive file pattern like ~/projects/home_notes/**/*.norg doesn't work?
    autocmd BufWritePost ~/projects/home_notes/*.norg silent !git -C ~/projects/home_notes/ add . && git -C ~/projects/home_notes/ commit -m "Update home notes" && git -C ~/projects/home_notes/ push
  augroup END
]])

-- COPILOT.VIM
-- https://github.com/github/copilot.vim
vim.cmd([[
  let g:copilot_filetypes = { 'norg': v:false }
]])

-- GENERAL
local set = vim.opt
-- autoindent new lines
set.autoindent = true
-- expands tabs into spaces
set.expandtab = true
-- number of spaces to use for each tab
set.tabstop = 2
-- number of spaces to use when indenting
set.shiftwidth = 2
-- number of spaces to use for (auto)indent step
set.softtabstop = 2
set.ignorecase = true
set.smartcase = true
set.number = true
set.splitbelow = true
set.splitright = true
-- set.scrolloff = 999
set.hlsearch = false
set.wildignore = "node_modules/*"
set.number = true
set.relativenumber = true
vim.cmd([[autocmd FileType * set formatoptions-=ro]])
set.syntax = "on"
set.termguicolors = true
set.virtualedit = "block"
set.inccommand = "split"
-- https://stackoverflow.com/questions/4642822/how-to-make-bashrc-aliases-available-within-a-vim-shell-command
set.shellcmdflag = "-ic"
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("i", "<C-b>", "<CR><ESC>kA<CR>", { silent = true })
vim.keymap.set("i", "<C-o>", "<CR><ESC>I")
-- do not open folds when searching for text
vim.cmd([[set foldopen-=search]])
-- do not open folds when moving cursor
