---@diagnostic disable: undefined-global

return {
	s("rli", fmt([[ <li key={{{}}}>{{{}}}</li> ]], { i(1), i(2) })),
  s("dnl", fmt([[ // eslint-disable-next-line {} ]], { i(1, "rule-to-ignore") })),
  s("pt",
    fmt(
      [[ 
        {}.propTypes = {{
          {}
        }}
      ]],
      { i(1), i(2) }
    ))
}
