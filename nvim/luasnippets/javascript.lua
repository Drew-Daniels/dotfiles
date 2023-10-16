---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s("rli", fmt([[ <li key={{{}}}>{{{}}}</li> ]], { i(1), i(2) })),
	s("dnl", fmt([[ // eslint-disable-next-line {} ]], { i(1, "rule-to-ignore") })),
	s(
		"des",
		fmt(
			[[
        /* eslint-disable {} */
        {}
        /* eslint-enable {} */
      ]],
			{
				i(1, "rule-to-ignore"),
				d(2, get_visual),
				r(1, "rule-to-ignore"),
			}
		)
	),
	s(
		"pt",
		fmt(
			[[ 
        {}.propTypes = {{
          {}
        }}
      ]],
			{ i(1), i(2) }
		)
	),
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
        beforeAll('<>', () =>> {
          <>
        });
      ]],
			{ i(1), i(2) }
		),
		{ desc = "jest beforeAll" }
	),
	s(
		"jbe",
		fmta(
			[[ 
        beforeEach('<>', () =>> {
          <>
        });
      ]],
			{ i(1), i(2) }
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
	s(
		"nf",
		fmta(
			[[ 
        function <>() {
          <>     
        }
      ]],
			{ i(1), i(2) },
      { desc = "JS Named Function" } 
		)
	),
	s(
		">>",
		fmta(
			[[
        (<>) =>> {<>}
      ]],
			{ i(1), i(2) },
      { desc = "JS Arrow Function" } 
		)
	),
}
