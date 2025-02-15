---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("rf", fmta("const <> = ref(<>)", { i(1), i(2) }), { desc = "Ref" }),
  s("rc", fmta("const <> = reactive(<>)", { i(1), i(2) }), { desc = "Reactive" }),
  --TODO: Add choice node for arrow fn returning object or function with explicit return statement
  s("cp", fmta("const <> = computed(() =>> {<>})", { i(1), i(2) }), { desc = "Comptuted Property" }),
  --TODO: Add newline, tab before interpolation
  --TODO: Add choice node for adding 'scope' directive
  s("tm", fmt("<template{}>{}</template>", { c(1, { t(""), i(1) }), i(2) }), { desc = "Template" }),
  s("st", fmt("<style{}>{}</style>", { c(1, { t(""), t(" scoped") }), i(2) }), { desc = "Style Tag" }),
}
