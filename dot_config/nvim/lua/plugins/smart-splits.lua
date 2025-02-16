return {
  "mrjones2014/smart-splits.nvim",
  opts = {
    resize_mode = { hooks = { on_leave = require("bufresize").register } },
  },
  config = function(_, opts)
    require("smart-splits").setup(opts)
  end,
}
