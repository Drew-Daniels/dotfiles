local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- must map leader key before "lazy" setup
vim.g.mapleader = " "
vim.g.maplocalleader = ","

return require("lazy").setup({
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    -- tag = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
	{
		"nvim-neotest/neotest",
		lazy = true,
		dependencies = {
			"olimorris/neotest-rspec",
			"nvim-neotest/neotest-jest",
		},
	},
	{ "github/copilot.vim" },
	{ "nvim-telescope/telescope-media-files.nvim", dependencies = { "nvim-lua/popup.nvim" } },
	{
		"piersolenski/telescope-import.nvim",
		requires = "nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").load_extension("import")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	{
		"stevearc/overseer.nvim",
		opts = {},
		-- optional for nicer ui
		dependencies = { "rcarriga/nvim-notify", "stevearc/dressing.nvim" },
	},
	{
		"folke/zen-mode.nvim",
		opts = {},
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true,
	},
	{ "ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" } },
	"dfendr/clipboard-image.nvim",
	"karb94/neoscroll.nvim",
	"mxsdev/nvim-dap-vscode-js",
	"barklan/capslock.nvim",
	"stevearc/conform.nvim",
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	{ "folke/neodev.nvim", opts = {} },
	"ray-x/web-tools.nvim",
	{ "rest-nvim/rest.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	"ludovicchabant/vim-gutentags",
	"RRethy/nvim-treesitter-endwise",
	"williamboman/mason.nvim",
	"tpope/vim-fugitive", -- Git operations, tools in neovim
	"junegunn/gv.vim", -- Pretty Git log
	"navarasu/onedark.nvim",
	"xiyaowong/transparent.nvim",
	-- recommended settings from 'nvim-lspconfig'
	"neovim/nvim-lspconfig",
	"hrsh7th/nvim-cmp", -- Autocompletion plugin
	"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
	"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
	"L3MON4D3/LuaSnip", -- Snippets plugin
	-- dap
	"williamboman/mason.nvim",
	"mfussenegger/nvim-dap",
	--
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			highlight = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
	},
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
})
