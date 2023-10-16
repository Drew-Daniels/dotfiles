---@diagnostic disable: undefined-global

return {
	s("tb", fmta([[ { <> }]], { i(1) }), { desc = "Lua Table" }),
	s("tf", fmta([[ <> = <>]], { i(1), i(2) }), { desc = "Lua Table Field" }),
	s("td", fmta([[--TODO: <>]], { i(2) }), { desc = "TODO Note" }),
  --TODO: Figure out why this doesn't work
-- 	s("sn",
-- 		fmta(
--       [=[
--         s("<>"),
--           fmta(
--             [[]],
--             { <> },
--             { desc = "<>" }
--           )
--       ]=]
--     ),
--     { i(1, "trigger"), i(2, "nodes"), i(3, "description") },
--     { desc = "Snippet snippet" }
-- 	)
}
