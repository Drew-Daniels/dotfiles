return {
  "stevearc/oil.nvim",
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function (_, opts)
    require("oil").setup(opts)
  end
}
