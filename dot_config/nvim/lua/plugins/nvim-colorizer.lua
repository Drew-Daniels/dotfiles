return {
	"norcalli/nvim-colorizer.lua",
	config = function(_, opts)
		require("colorizer").setup(opts)
	end,
}
