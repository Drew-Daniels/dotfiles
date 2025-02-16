return {
  "nvim-neorg/neorg",
  dependencies = { "luarocks.nvim" },
  lazy = false,
  version = "*",
  opts = {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.dirman"] = {  -- Manages Neorg workspaces
        config = {
          workspaces = {
            su = "~/projects/work_notes/su/2024",
            ooo = "~/projects/work_notes/ooo/2024",
          },
        },
      },
      ["core.keybinds"] = { config = { default_keybinds = {} } },
    },
  },
  config = function(_, opts)
    require("neorg").setup(opts)
  end
}
