---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "exs",
    fmta(
      [[
        execute <<<<-SQL
          <>
        ;
        SQL]],
      { i(1) },
      { desc = "ActiveRecord SQL Execute Statement" }
    )
  ),
}
