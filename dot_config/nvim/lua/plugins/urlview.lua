return {
  "axieax/urlview.nvim",
  dependencies = {
    -- NOTE: Not a hard-requirement, but only alternatives are vim.ui.select or Telescope.nvim
    -- TODO: Create integration with fzf-lua so I can use this as a picker instead

  },
  opts = {
    default_picker = "snacks",
  },
}
