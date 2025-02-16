return {
  "nvim-treesitter/nvim-treesitter-context",
  opts = {
    max_lines = 5,
  },
  config = function(_, opts)
    require("treesitter-context").setup(opts)
  end
}
