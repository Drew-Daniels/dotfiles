---@diagnostic disable: undefined-global

return {
  -- jsx
	s("rli", fmt([[ <li key={{{}}}>{{{}}}</li> ]], { i(1), i(2) })),
  -- react
	s("us", fmta([=[ const [<>, <>] = useState(<>) ]=], { i(1), i(2), i(3) })),
	s(
		"ue",
		fmta(
		  [=[ 
        useEffect(() =>> {
          <>
        }, [<>]);
      ]=],
			{ i(2), i(1) }
		)
	),
  -- PropTypes
	s(
		"pt",
		fmta(
			[[ 
        <>.propTypes = {
          <>: PropTypes.<>,
        }
      ]],
			{ i(1), i(2), i(3) }
		)
	),
  s(
    "dpt",
		fmta(
			[[ 
        <>.defaultProps = {
          <>: <>,
        }
      ]],
			{ i(1), i(2), i(3) }
  ))
}
