---@diagnostic disable: undefined-global

return {
  s("tb", fmta([[ { <> }]], { i(1) }), { desc = "Lua Table" }),
  s("tf", fmta([[ <> = <>]], { i(1), i(2) } ), { desc = "Lua Table Field" } ),
  s("td", fmta([[--TODO: <>]], { i(2) }), { desc = "TODO Note" })
}

