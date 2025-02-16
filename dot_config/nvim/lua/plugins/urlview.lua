return {
  "axieax/urlview.nvim",
  opts = {
    default_picker = "fzflua",
  },
  config = function(_, opts)
    require("urlview").setup(opts)
  end,
}
