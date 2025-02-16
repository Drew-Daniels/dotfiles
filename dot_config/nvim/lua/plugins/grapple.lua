return {
  "cbochs/grapple.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons", lazy = true },
  },
  opts = {
    scope = "git_branch",
    win_opts = {
      width = 150,
    },
  },
  config = function(_, opts)
    require("grapple").setup(opts)
  end,
}
