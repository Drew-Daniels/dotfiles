---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"cl",
		fmta(
			[[ 
        <>class <> {<>}
      ]],
			{ c(1, { t(""), t("export ") }), i(2), i(3) },
			{ desc = "Class" }
		)
	),
}
