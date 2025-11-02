return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {},
  -- NOTE: Disabling until typescript-tools adds support for `typescript.tsserverRequest`: https://github.com/neovim/nvim-lspconfig/pull/4030
  -- NOTE: I believe this is required for vue_ls and typescript integration to work correctly
  cond = false,
}
