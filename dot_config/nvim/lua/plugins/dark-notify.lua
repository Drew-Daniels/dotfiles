return {
	"cormacrelf/dark-notify",
	build = "brew install cormacrelf/tap/dark-notify",
	config = function(_, _)
		require("dark_notify").run({
			schemes = {
				-- light = "zenbones",
				-- dark = "zenbones",
				light = "zenbones",
				dark = "gruvbox",
			},
		})
	end,
}
