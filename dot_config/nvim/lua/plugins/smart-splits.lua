return {
	"mrjones2014/smart-splits.nvim",
	-- b65575045cc446833da726a46d447e96c6759c5e seems to have introduced a bug, or at least adds logging that makes it looks like there is a bug:
	-- tmux init: failed to detect pane_id
	commit = "c697ea84309db323e4da82d29c1f23304e6910be",
	opts = {
		resize_mode = { hooks = { on_leave = require("bufresize").register } },
	},
	config = function()
		vim.g.smart_splits_multiplexer_integration = "tmux"
	end,
}
