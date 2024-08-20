---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "cn",
    fmta(
      [[ 
        context('<>', () =>> {
          <>
        });
      ]],
      { i(1), i(2) }
    ),
    { desc = "Jest Context" }
  ),
  s(
    "ds",
    fmta(
      [[ 
        describe('<>', () =>> {
          <>
        });
      ]],
      { i(1), i(2) }
    ),
    { desc = "jest describe" }
  ),
  s(
    "ba",
    fmta(
      [[ 
        beforeAll(() =>> {
          <>
        });
      ]],
      { i(1) }
    ),
    { desc = "jest beforeAll" }
  ),
  s(
    "aa",
    fmta(
      [[ 
        afterAll(() =>> {
          <>
        });
      ]],
      { i(1) }
    ),
    { desc = "jest afterAll" }
  ),
  s(
    "be",
    fmta(
      [[ 
        beforeEach(<>() =>> {
          <>
        });
      ]],
      { c(1, { t(""), t("async ") }), i(2) }
    ),
    { desc = "jest beforeEach" }
  ),
  s(
    "ae",
    fmta(
      [[ 
        afterEach(() =>> {
          <>
        });
      ]],
      { i(1) }
    ),
    { desc = "jest afterEach" }
  ),
  s("jt", fmta([[ it('<>', () =>> {<>});]], { i(1), i(2) }), { desc = "jest test" }),
  s("jtd", fmta([[ it.todo('<>');]], { i(1) }), { desc = "jest test todo" }),
  s("ex", fmta([[ expect(<>)<>;]], { i(1), i(0) }), { desc = "jest expect" }),
  s("pt", fmta([[ test('<>', () =>> {<>});]], { i(1), i(2) }), { desc = "playwright test" }),
}
