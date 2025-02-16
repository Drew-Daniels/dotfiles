return {
	"dfendr/clipboard-image.nvim",
	--TODO: Figure out how to update the image path used in markdown links. Images are getting copied to /images/<image-name> correctly, but the markdown links reference /img/<image-name>.

	opts = {
		default = {
			img_dir = "images",
		},
	},
	config = function(_, opts)
		require("clipboard-image").setup(opts)
	end,
}
