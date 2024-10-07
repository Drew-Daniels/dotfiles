---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")

return {
  s(
    "fn",
    fmt(
[[function {}
  {}
end]],
      { i(1), i(2) },
      { desc = "fish function" }
    )
  ),
}
