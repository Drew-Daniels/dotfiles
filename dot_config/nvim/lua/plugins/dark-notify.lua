return {
	"cormacrelf/dark-notify",
	lazy = false,
	-- priority 1 lower than gruvbox.nvim
	priority = 999,
	build = function()
		if vim.fn.has("macunix") == 1 then
			return "brew install cormacrelf/tap/dark-notify"
		end
	end,
	cond = function()
		return vim.fn.has("macunix") == 1
	end,
	config = function(_, _)
		require("dark_notify").run({
			schemes = {
				-- light = "zenbones",
				-- dark = "zenbones",
				light = "gruvbox",
				dark = "gruvbox",
			},
		})
	end,
}
