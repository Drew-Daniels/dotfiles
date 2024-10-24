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
    dir = "~/projects/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets",
    dev = true,
  },
  {
    "chrisgrieser/nvim-scissors",
    dependencies = { "nvim-telescope/telescope.nvim", "garymjr/nvim-snippets" },
  },
  {
    "garymjr/nvim-snippets",
    dependencies = { "hrsh7th/nvim-cmp" },
    dir = "~/projects/nvim-snippets",
    url = "https://github.com/garymjr/nvim-snippets",
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
  -- -- Currently broken?
  -- {
  --   "Exafunction/codeium.vim",
  --   event = "BufEnter",
  -- },
  { "lewis6991/gitsigns.nvim" },
  { "sindrets/diffview.nvim" },
  { "axieax/urlview.nvim" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
  },
  { "LukasPietzschmann/telescope-tabs" },
  { "LudoPinelli/comment-box.nvim" },
  { "windwp/nvim-ts-autotag" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "mrjones2014/legendary.nvim", priority = 2000, lazy = false },
  {
    "kwkarlwang/bufresize.nvim",
    config = function()
      require("bufresize").setup()
    end,
  },
  { "mrjones2014/smart-splits.nvim" },
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  },
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
    "piersolenski/telescope-import.nvim",
    requires = "nvim-telescope/telescope.nvim",
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
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
  "RRethy/nvim-treesitter-endwise",
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
    dir = "~/projects/blink.cmp",
    url = "https://github.com/Saghen/blink.cmp",
    -- dev = true,
    version = "v0.*",
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
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
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
    dir = "~/projects/octo.nvim",
    url = "https://github.com/pwntester/octo.nvim",
    dev = false,
  },
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
  },
})
