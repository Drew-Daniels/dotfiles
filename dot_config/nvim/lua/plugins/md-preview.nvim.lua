return {
	"Drew-Daniels/md-preview.nvim",
	build = "zig build -Doptimize=ReleaseFast",
	dev = true,
	ft = "markdown",
	cmd = { "MdPreview", "MdPreviewStop", "MdPreviewToggle" },
	config = function()
		require("md-preview").setup()
	end,
}
