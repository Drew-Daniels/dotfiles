---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  -- imports
	s(
		"esi",
		fmta(
			[[
        import <> from '<>';
      ]],
			{ c(2, { sn(nil, { t"{ ", i(1), t" }" }), t"" }), i(1) },
			{ desc = "ES Module Import" }
		)
	),
	s(
		"cji",
		fmta(
			[[
        const <> = require('<>');
      ]],
			{ c(2, { sn(nil, { t"{ ", i(1), t" }" }), t"" }), i(1) },
			{ desc = "CommonJS Module Import" }
		)
	),
	s(
		"nr",
		fmta(
			[[
        const <> = require('<>');
      ]],
			{ i(2), i(1) },
			{ desc = "Named require" }
		)
	),
  -- exports
	s("ese", fmta([[ export <><> ]], { c(1, { t"default ", t"" }), i(2) }), { desc = "ES Module export" }),
	s(
		"cjs",
		fmta(
			[[
        module.exports = {
          <>,
        }
      ]],
			{ i(1) },
      { desc = "CommonJS Export" }
		)
	),
  -- eslint
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
  -- testing
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
  -- functions
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
