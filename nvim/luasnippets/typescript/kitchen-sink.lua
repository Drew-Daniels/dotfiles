---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "in",
    fmta(
      [[
        <>interface <> {
          <>: <>
        }
      ]],
      {
        c(1, { t(""), t("export ") }),
        i(2),
        i(3),
        i(4),
      }
    )
  ),
  s(
    "ty",
    fmta(
      [[
        <>type <> = {
          <>: <>
        }
      ]],
      {
        c(1, { t(""), t("export ") }),
        i(2),
        i(3),
        i(4),
      }
    )
  ),
  s(
    "cd",
    fmta(
      [[ 
        <>class <> {<>}
      ]],
      { c(1, { t(""), t("export ") }), i(2), i(3) },
      { desc = "Class Definition" }
    )
  ),
  s(
    "cc",
    fmta(
      [[ 
        constructor(<>) {<>}
      ]],
      { i(1), i(2) },
      { desc = "Class Constructor" }
    )
  ),
  s(
    "cm",
    fmta(
      [[ 
        <><><>(<>)<> {<>}
      ]],
      {
        c(1, { t(""), t("static "), t("private ") }),
        c(2, { t(""), t("async ") }),
        i(3),
        i(4),
        c(5, { t(""), { t(": "), i(1) } }),
        i(6),
      },
      { desc = "Class Method" }
    )
  ),
  s(
    "cs",
    fmta(
      [[ 
        super(<>)
      ]],
      { i(1) },
      { desc = "Class Super" }
    )
  ),
}
