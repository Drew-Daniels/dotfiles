---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"jd",
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
		"jba",
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
		"jbe",
		fmta(
			[[ 
        beforeEach(() =>> {
          <>
        });
      ]],
			{ i(1) }
		),
		{ desc = "jest beforeAll" }
	),
	s("jt", fmta([[ it('<>', () =>> {<>});]], { i(1), i(2) }), { desc = "jest test" }),
	s("jx", fmta([[ expect(<>)<>;]], { i(1), i(0) }), { desc = "jest expect" }),
	s(
		"jf",
		fmta(
			[[ <>('<>', () =>> {<>}); ]],
			{ c(1, { t("describe"), t("it"), t("beforeAll"), t("beforeEach") }), i(2), i(3) }
		)
	),
}
