return {
	"kndndrj/nvim-dbee",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	build = function()
		-- Install tries to automatically detect the install method.
		-- if it fails, try calling it with one of these parameters:
		--    "curl", "wget", "bitsadmin", "go"
		require("dbee").install()
	end,
	-- TODO: See if I can refactor this to use opts = {} instead of config = ...
	config = function()
		require("dbee").setup({
			sources = {
				-- require("dbee.sources").MemorySource:new({
				-- 	{
				--         id = "some-really-unique-id",
				-- 		name = "...",
				-- 		type = "...",
				-- 		url = "...",
				-- 	},
				-- }),
				-- require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
				-- TODO: Refactor so DB creds aren't stored on disk
				require("dbee.sources").FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),
			},
		})
	end,
}
