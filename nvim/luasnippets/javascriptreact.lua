---@diagnostic disable: undefined-global

return {
	s("rli", fmt([[ <li key={()}>{()}</li> ]], { i(1), i(2) }, { delimiters = "()" })),
}
