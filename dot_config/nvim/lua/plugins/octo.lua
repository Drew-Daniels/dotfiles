return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    default_to_projects_v2 = true,
    mappings_disable_default = true,
  },
  config = function(_, opts)
    require("octo").setup(opts)
  end,
}
