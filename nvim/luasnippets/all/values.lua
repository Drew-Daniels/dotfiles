---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "dq",
    fmta([["<>"]], {
      i(1),
    }, { desc = "Double-Quoted String" })
  ),
  s(
    "sq",
    fmta([['<>']], {
      i(1),
    }, { desc = "Single-Quoted String" })
  ),
}
