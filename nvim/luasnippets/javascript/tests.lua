---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
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
		"be",
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
	s("ts", fmta([[ it('<>', () =>> {<>});]], { i(1), i(2) }), { desc = "jest test" }),
	s("ex", fmta([[ expect(<>)<>;]], { i(1), i(0) }), { desc = "jest expect" }),
	s(
		"be",
		fmta(
			[[ <>('<>', () =>> {<>}); ]],
			{ c(1, { t("describe"), t("it"), t("beforeAll"), t("beforeEach") }), i(2), i(3) }
		)
	),
}
