---@diagnostic disable: undefined-global

local get_visual = function(args, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

return {
	s(
		"q",
		fmta([["<>"]], {
			d(1, get_visual),
		})
	),
	s(
		"b",
		fmta([[{<>}]], {
			d(1, get_visual),
		})
	),
	s(
		"p",
		fmta([[(<>)]], {
			d(1, get_visual),
		})
	),
}
