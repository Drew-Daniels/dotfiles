---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

--TODO: Determine how to implement choice nodes that can be used to create a new todo, but also cycle through varying levels of indentdation (-, --, ---, etc.)
return {
  s(
    "td",
    fmta(
      [[
        - ( ) <>
      ]],
      {
        i(1),
      }
    )
  ),
}
