---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "mi",
    fmta(
      [[
        <>.map((<>, i), =>> {
          <> 
        })
      ]],
      { i(1), i(2), i(3) },
      { desc = "Map Items" }
    )
  ),
}
