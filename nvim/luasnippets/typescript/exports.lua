---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s("ese", fmta([[ export <><> ]], { c(1, { t("default "), t("") }), i(2) }), { desc = "ES Module export" }),
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
}
