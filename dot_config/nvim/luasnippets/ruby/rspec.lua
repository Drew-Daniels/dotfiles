---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  --TODO: Make 'it' snippet containing choice nodes that can alternate between single-line, and multi-line
  -- rspec tests
  s("its", fmta([[it { <> }]], { i(1) }), { desc = "RSpec test - single-line" }),
  s("su", fmta([[subject { <> }]], { i(1) }), { desc = "RSpec test - subject" }),
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
    "sp",
    fmta(
      [[
        specify do
          expect(<>).<>
        end
      ]],
      { i(1), i(2) }
    ),
    { desc = "RSpec test - specify" }
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
  s("bf", fmta([[before { <> }]], { i(1) }), { desc = "RSpec before" }),
  s("ex", fmta([[expect(<>).<>]], { i(1), i(2) }), { desc = "RSpec expect" }),
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
  ),
}
