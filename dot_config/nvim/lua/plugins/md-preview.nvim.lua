return {
	"Drew-Daniels/md-preview.nvim",
	build = "zig build -Doptimize=ReleaseFast",
	dev = true,
	ft = "markdown",
	config = function()
		require("md-preview").setup()
	end,
}
