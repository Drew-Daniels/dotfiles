return {
	"mrjones2014/smart-splits.nvim",
	opts = {
		resize_mode = { hooks = { on_leave = require("bufresize").register } },
	},
	config = function()
		vim.g.smart_splits_multiplexer_integration = "tmux"
	end,
}
