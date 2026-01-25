return {
	"catgoose/nvim-colorizer.lua",
	opts = {
		user_default_options = {
			names = false,
		},
	},
	-- NOTE: If I want to attach nvim-colorizer to every buffer automatically, use 'config' instead of 'opts'
	-- config = function ()
	--   require("colorizer").setup()
	-- end
}
