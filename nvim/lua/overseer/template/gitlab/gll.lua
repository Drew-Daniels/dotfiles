return {
	name = "gll",
	builder = function()
		return {
			cmd = { "gll" },
			name = "GitLab CI Config Lint",
		}
	end,
	desc = "Lints GitLab CI Configuration file in PWD",
}
