return {
	"Drew-Daniels/md-preview.nvim",
	build = "zig build -Doptimize=ReleaseFast",
	dev = true,
	ft = "markdown",
	cmd = { "MdPreview", "MdPreviewStop", "MdPreviewToggle" },
	opts = {
		-- theme = "gruvbox",
		theme = {
			light = "catppuccin",
			dark = "gruvbox",
		},
	},
}
