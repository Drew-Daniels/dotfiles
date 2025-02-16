return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}
