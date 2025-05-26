return {
	"cormacrelf/dark-notify",
	build = function ()
	  if vm.fn.has("macunix") == 1 then
	    return "brew install cormacrelf/tap/dark-notify"
	  end
	end,
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
