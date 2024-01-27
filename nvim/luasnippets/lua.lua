---@diagnostic disable: undefined-global

return {
	s("tb", fmta([[ { <> }]], { i(1) }), { desc = "Lua Table" }),
	s("tf", fmta([[ <> = <>]], { i(1), i(2) }), { desc = "Lua Table Field" }),
	s("td", fmta([[--TODO: <>]], { i(2) }), { desc = "TODO Note" }),
	s("tn", fmta([[t(<>)]], { i(1) }), { desc = "Luasnip Text Node" }),
	s("cn", fmta([[c(<>, { <>, <> })]], { i(1), i(2), i(3) }), { desc = "Luasnip Choice Node" }),
}
