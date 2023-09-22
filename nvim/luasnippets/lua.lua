---@diagnostic disable: undefined-global

return {
  -- TODO: place cursor in between brackets
  s(
    { trig = "tb" },
    fmt(
      [[
        { <> }
      ]],
      { i(1) },
      { delimiters = "<>" }
    )
  ),
}

