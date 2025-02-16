return {
  "sindrets/diffview.nvim",
  opts = {
    view = {
      merge_tool = {
        layout = "diff4_mixed",
      },
    },
  },
  config = function(_, opts)
    require("diffview").setup(opts)
  end,
}
