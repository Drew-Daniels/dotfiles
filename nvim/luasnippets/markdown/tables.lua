---@diagnostic disable: undefined-global

return {
  --TODO: Figure out a way to dynamically choose how many columns, rows are generated
  s(
    "tb",
    fmta(
      [[
        | <> | <> |
        | -- | -- |
        | <> | <> |
      ]],
      { i(1), i(2), i(3), i(4) },
      { desc = "Table" }
    )
  ),
  s(
    "ba",
    fmta(
      [[
        | Before | After |
        | -- | -- |
        |  |  |
      ]],
      {},
      { desc = "Before & After Table" }
    )
  ),
}
