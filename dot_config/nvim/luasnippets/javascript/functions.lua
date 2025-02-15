---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "nf",
    fmta(
      [[ 
        <><>function <>(<>) {
          <>     
        }
      ]],
      { c(1, { t(""), t("export ") }), c(2, { t(""), t("async ") }), i(3), i(4), i(5) },
      { desc = "Named Fn" }
    )
  ),
  s(
    "na",
    fmta(
      [[
        <><>const <> = (<>) =>> {<>}
      ]],
      { c(1, { t(""), t("export ") }), c(2, { t(""), t("async ") }), i(3), i(4), i(5) },
      { desc = "Named Arrow Fn" }
    )
  ),
  s(
    "aa",
    fmta(
      [[
        (<>) =>> {<>}
      ]],
      { i(1), i(2) },
      { desc = "Anonymous Arrow Fn" }
    )
  ),
}
