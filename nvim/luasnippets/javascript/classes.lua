---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"cs",
		fmta(
			[[ 
        <>class <> {<>}
      ]],
			{ c(1, { t(""), t("export ") }), i(2), i(3) },
			{ desc = "Class" }
		)
	),
	s(
		"cc",
		fmta(
			[[ 
        constructor(<>) {<>}
      ]],
			{ i(1), i(2) },
			{ desc = "Constructor" }
		)
	),
	s(
		"cm",
		fmta(
			[[ 
        <>(<>) {<>}
      ]],
			{ c(1, { t(""), t("static "), t("private ") }), i(2), i(3) },
			{ desc = "Method" }
		)
	),
	s(
		"sp",
		fmta(
			[[ 
        super(<>)
      ]],
			{ i(1) },
      { desc = "Super" }
		)
	),
}
