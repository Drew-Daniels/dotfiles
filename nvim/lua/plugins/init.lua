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
  config = {
    dev = {
      path = "~/projects",
    },
  },
  -- {
  --   "ggml-org/llama.vim",
  -- },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({
        lsp = {
          async_or_timeout = 10000,
        },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case",
          RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
        },
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  { "cormacrelf/dark-notify" },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      -- suggested keymap
      { "<leader>P", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
  { "rcarriga/nvim-notify" },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {
    "rafamadriz/friendly-snippets",
    dev = true,
  },
  {
    "chrisgrieser/nvim-scissors",
    dependencies = { "nvim-telescope/telescope.nvim", "garymjr/nvim-snippets" },
  },
  {
    "garymjr/nvim-snippets",
    dependencies = { "hrsh7th/nvim-cmp" },
    -- dev = true,
  },
  {
    "norcalli/nvim-colorizer.lua",
  },
  {
    "barrett-ruth/live-server.nvim",
    build = "npm i -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  -- {
  --   "Exafunction/codeium.vim",
  --   event = "BufEnter",
  --   -- dev = true,
  -- },
  { "lewis6991/gitsigns.nvim" },
  { "sindrets/diffview.nvim" },
  { "axieax/urlview.nvim" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
  },
  { "LudoPinelli/comment-box.nvim" },
  { "windwp/nvim-ts-autotag" },
  { "nvim-treesitter/nvim-treesitter-context" },
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  },
  { "mrjones2014/legendary.nvim", priority = 2000, lazy = false },
  {
    "kwkarlwang/bufresize.nvim",
    config = function()
      require("bufresize").setup()
    end,
  },
  { "mrjones2014/smart-splits.nvim" },
  {
    "vhyrro/luarocks.nvim",
    priority = 3000,
    config = true,
  },
  {
    "nvim-neorg/neorg",
    dependencies = { "luarocks.nvim" },
    lazy = false,
    version = "*",
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim", "rafi/telescope-thesaurus.nvim" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    build = ":TSUpdate",
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  {
    "numToStr/Comment.nvim",
    opts = {},
    lazy = false,
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
  {
    "cbochs/grapple.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
  },
  "dfendr/clipboard-image.nvim",
  "karb94/neoscroll.nvim",
  "stevearc/conform.nvim",
  "ray-x/web-tools.nvim",
  "ludovicchabant/vim-gutentags",
  -- "RRethy/nvim-treesitter-endwise",
  -- Using fork until https://github.com/RRethy/nvim-treesitter-endwise/pull/42 is merged
  "metiulekm/nvim-treesitter-endwise",
  "tpope/vim-fugitive", -- Git operations, tools in neovim
  "tpope/vim-rhubarb", -- Fugitive-companion to interact with github
  { "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
  "xiyaowong/transparent.nvim",
  -- recommended settings from 'nvim-lspconfig'
  "neovim/nvim-lspconfig",
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    -- dev = true,
    version = "v0.10.0",
    -- version = "v0.*",
    -- NOTE: Need to run this build manually
    -- build = "cargo build --release",
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
    dependencies = {
      { "echasnovski/mini.icons", version = false },
    },
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
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  { "tpope/vim-rails" },
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    -- dev = true,
  },
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
  },
})
