return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    snippet_engine = "nvim"
  },
  config = function(_, opts)
    require("neogen").setup(opts)
  end,
}
