---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "cm",
    fmta(
      [[
        def self.<>
          <>
        end
      ]],
      { i(1), i(2) }
    ),
    { desc = "Class Method" }
  ),
  s(
    "im",
    fmta(
      [[
        def <>
          <>
        end
      ]],
      { i(1), i(2) }
    ),
    { desc = "Instance Method" }
  ),
}
