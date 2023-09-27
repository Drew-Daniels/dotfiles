---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s("rli", fmt([[ <li key={{{}}}>{{{}}}</li> ]], { i(1), i(2) })),
  s("dnl", fmt([[ // eslint-disable-next-line {} ]], { i(1, "rule-to-ignore") })),
  s("des",
    fmt(
      [[
        /* eslint-disable {} */
        {}
        /* eslint-enable {} */
      ]]
      ,
      {
        i(1, "rule-to-ignore"),
        d(2, get_visual),
        r(1, "rule-to-ignore"),
      })
  ),
  s("pt",
    fmt(
      [[ 
        {}.propTypes = {{
          {}
        }}
      ]],
      { i(1), i(2) }
    )),
  -- TODO: Make snippets for jest tests, describe blocks
  -- TODO: Make snippet for selecting code and commenting it out
}
