---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "oo",
    fmta(
      [[
        * One on One <>

        ** Agenda
          - <>

        ** Action Items
          - <>

      ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
}
