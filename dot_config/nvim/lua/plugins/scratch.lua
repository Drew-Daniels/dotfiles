return {
  "LintaoAmons/scratch.nvim",
  event = "VeryLazy",
  opts = {
    file_picker = "fzflua",
    filetypes = { "js", "json", "sql", "sh", "ruby" },
  },
  config = function(_, opts)
    require("scratch").setup(opts)
  end,
}
