return {
	"rcarriga/nvim-notify",
	opts = {
		background_colour = "#000000",
		render = "compact",
	},
	config = function(_, opts)
		require("notify").setup(opts)
	end,
}
