---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "su",
    fmta(
      [[
        * Standup <>

        ** What did I do yesterday?
          <>

        ** What am I doing today?
          <>

        ** What's blocking me?
          <>

        * Work TODO
          - ( ) <>

        * Personal TODO
          - ( ) <>

      ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
      }
    )
  ),
}
