---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("rf", fmta("const <> = ref(<>)", { i(1), i(2) }), { desc = "Ref" }),
  s("rc", fmta("const <> = reactive(<>)", { i(1), i(2) }), { desc = "Reactive" }),
  --TODO: Add choice node for arrow fn returning object or function with explicit return statement
  s("cp", fmta("const <> = computed(() =>> {<>})", { i(1), i(2) }), { desc = "Comptuted Property" }),
}
