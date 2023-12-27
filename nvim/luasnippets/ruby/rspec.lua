---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  --TODO: Make 'it' snippet containing choice nodes that can alternate between single-line, and multi-line
  -- rspec tests
	s("its", fmta([[it { <> }]], { i(1) }), { desc = "RSpec test - single-line" }),
	s(
		"itm",
		fmta(
      [[
        it '<>' do
          <>
        end
      ]],
      { i(1), i(2) }
    ),
    { desc = "RSpec test - multi-line" }
	),
  s(
    "ds",
    fmta(
      [[
        describe '<>' do
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
  ),
  s(
    "ex",
    fmta(
      [[expect(<>).<>]], { i(1), i(2) }
    ), { desc = "RSpec expect" }
  ),
  s(
    "cn",
    fmta(
      [[
        context '<>' do
          <>
        end
      ]],
      { i(1), i(2) }
    ),
    { desc = "RSpec context" }
  )
}
