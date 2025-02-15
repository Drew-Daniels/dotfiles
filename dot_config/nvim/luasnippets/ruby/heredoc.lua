---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "jsh",
    fmta(
      [[
        <<<<-JSON
          <>
        JSON]],
      { i(1) },
      { desc = "JSON heredoc" }
    )
  ),
}
