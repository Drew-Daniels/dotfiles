---@diagnostic disable: undefined-global

return {
  s(
    { trig = "bs", dscr = "bash code snippet" },
    fmta(
      [[
        ```bash
        <>
        ```
        <>
      ]],
      { i(1), i(0) }
    )
  ),
  s(
    "cs",
    fmta(
      [[
        ```<>
        <>
        ```
      ]],
      { i(1), i(0) }
    )
  ),
}
