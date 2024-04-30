---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s("us", fmta([=[ const [<>, <>] = useState(<>) ]=], { i(1), i(2), i(3) })),
	s(
		"ue",
		fmta(
			[=[ 
        useEffect(() =>> {
          <>
        }, [<>]);
      ]=],
			{ i(2), i(1) }
		)
	),
	s("rtd", fmt("{{/* TODO: {} */}}", { i(1) }), { desc = "React TODO" }),
}
