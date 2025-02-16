return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    lsp = {
      async_or_timeout = 10000,
    },
    grep = {
      rg_opts = "--column --line-number --no-heading --color=always --smart-case",
      RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
    },
  },
}
