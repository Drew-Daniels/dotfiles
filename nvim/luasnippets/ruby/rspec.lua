---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"it",
		fmta(
      [[
        it "<>" do
          <>
        end
      ]],
      { i(1), i(2) }
    ),
    { desc = "RSpec test" }
	),
  s(
    "ds",
    fmta(
      [[
        describe "<>" do
          <>
        end
      ]],
      { i(1), i(2) }
    ),
    { desc = "RSpec describe" }
  ),
  s(
    "b4",
    fmta(
      [[before { <> }]], { i(1) }
    ), { desc = "RSpec before" }
  )
}
