---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
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
}
