---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"cn",
		fmta(
			[[ 
        context("<>", () =>> {
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
        describe("<>", () =>> {
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
        beforeEach(() =>> {
          <>
        });
      ]],
			{ i(1) }
		),
		{ desc = "jest beforeAll" }
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
	s("jt", fmta([[ it("<>", () =>> {<>});]], { i(1), i(2) }), { desc = "jest test" }),
	s("ex", fmta([[ expect(<>)<>;]], { i(1), i(0) }), { desc = "jest expect" }),
	s(
		"be",
		fmta(
			[[ <>("<>", () =>> {<>}); ]],
			{ c(1, { t("describe"), t("it"), t("beforeAll"), t("beforeEach") }), i(2), i(3) }
		)
	),
}
