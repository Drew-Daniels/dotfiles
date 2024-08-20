---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "bk",
    fmta([[{ <> }]], {
      i(1),
    }, { desc = "Block" })
  ),
  s(
    "ls",
    fmta("[ <> ]", {
      i(1),
    }, { desc = "List" })
  ),
}
