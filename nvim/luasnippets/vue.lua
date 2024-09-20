---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("td", fmt("<!-- TODO: {} -->", { i(1) }), { desc = "TODO" }),
  s("rf", fmta("const <> = ref(<>)", { i(1), i(2) }), { desc = "Ref" }),
  s("rc", fmta("const <> = reactive(<>)", { i(1), i(2) }), { desc = "Reactive" }),
  --TODO: Add choice node for arrow fn returning object or function with explicit return statement
  s("cp", fmta("const <> = computed(() =>> {<>})", { i(1), i(2) }), { desc = "Comptuted Property" }),
  --TODO: Add newline, tab before interpolation
  s("ss", fmt("<style scoped>{}</style>", { i(1) }), { desc = "Scoped Style Tag" }),
}
